import gleam/io
import gleam/list
import gleam/int
import gleam/string
import gleam/result
import simplifile
import glint
import argv


fn entries_flag() -> glint.Flag(Int) {
  glint.int_flag("n")
  |> glint.flag_default(1)
  |> glint.flag_help("Number of entries to print")
}

fn knave() -> glint.Command(Nil) {
  use <- glint.command_help("")
  use entries <- glint.flag(entries_flag())

  use _, args, flags <- glint.command()
  
  let name = case args {
    [] -> "text"
    [name, ..] -> name
  }

  let assert Ok(entries) = entries(flags)

  let assert True = {
    entries > 0
  }
  


  let table_dir= "./tables/"
  let table_path_list : List(String) = {
    case simplifile.get_files(table_dir) {
      Ok(file_dirs) -> file_dirs
      Error(_) -> panic as "could not get file dirs"
    }
  }
  case get_tables(table_path_list) {
    tables -> {
      print_from_table(name, entries, tables)
    }
  }

}

pub fn main() {
  glint.new()
  |> glint.with_name("knave")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: knave())
  |> glint.run(argv.load().arguments)
}

pub fn get_tables(table_paths: List(String)) -> List(#(String, List(String))) {
  case table_paths {
    [x, ..xs] -> [{
      #(
        get_table_name_from_path(x),
        {
          simplifile.read(x)
          |> result.lazy_unwrap(fn ()  { "" })
          |> string.split("\n")
          |> list.map(string.trim)
          |> list.filter(fn(str) {
            case string.length(str) {
              0 -> False
              _ -> True
            }
          })
        }
      )
    }, ..get_tables(xs)]
    [] -> []
  }
}

pub fn get_table_name_from_path (path: String) -> String {
  path
  |> string.drop_right(4)
  |> string.crop("/")
  |> string.drop_left(1)
  |> string.crop("/")
  |> string.drop_left(1)
}

pub fn print_from_table (name: String, num: Int, tables: List(#(String, List(String)))) -> Nil {
  case num {
    0 -> Nil
    i -> {
      io.println(random_from_table(name, tables))
      print_from_table(name, i-1, tables)
    }
  }
} 

pub fn random_from_table (name: String, tables: List(#(String, List(String)))) -> String {
 let table = {
   tables
   |> list.filter(fn(entry) {
    let #(entry_name, _) = entry
    entry_name == name
   })
   |> head()
 } 

 let #(_, table_entries) = table
 
 at(table_entries, int.random(list.length(table_entries)))
}

pub fn head(x) {
  case x {
    [head, .._] -> head
    [] -> panic as "AAA"
  }
}

pub fn at(x, i) {
  case i {
    0 -> {
      case x {
        [head, .._] -> head
        _ -> panic as "AJSDKL:ASDKJ"
      }
    } 
    _ -> {
      case x {
        [_, ..rest] -> at(rest, i-1)
        _ -> panic as "JDFSKLJFK:DS"
      }
    }
  }
}