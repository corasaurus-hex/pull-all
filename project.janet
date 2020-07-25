(declare-project
 :name "pull-all"
 :description "Pulls all the immediately nested git repositories and the current directory."
 :dependencies ["https://github.com/andrewchambers/janet-sh.git"
                "https://github.com/janet-lang/path.git"])

(declare-executable
 :name "pull-all"
 :entry "pull-all.janet")
