(import sh)
(import path :as p)

(def ansi
  {:success "\e[32m"
   :error "\e[31m"
   :info "\e[33m"
   :reset "\e[39;49m"})

(defn success [msg]
  (string (ansi :success) msg (ansi :reset)))

(defn err [msg]
  (string (ansi :error) msg (ansi :reset)))

(defn color-result [res msg]
  (if (= res :success)
    (success msg)
    (err msg)))

(defn indent
  [text level]
  (let [indentation (string/repeat " " level)
        lines (string/split "\n" text)
        indented-text (string/join lines (string "\n" indentation))]
    (string indentation indented-text)))

(defn info [msg]
  (string/join @[(ansi :info) msg (ansi :reset)]))

(defn is-dir? [path]
  (= :directory
     (os/stat path :mode)))

(defn dirs [path]
  (->> (os/dir path)
    (map |(p/join path $0))
    (filter |(is-dir? $0))))

(defn hidden? [path]
  (string/has-prefix?
   "."
   (p/basename path)))

(defn visible? [path]
  (not (hidden? path)))

(defn visible-dirs [path]
  (filter visible? (dirs path)))

(defn git-project? [path]
  (is-dir? (p/join path ".git")))

(defn- search-directories [path depth]
  (if (> depth 0)
    (array/push (mapcat |(search-directories $0 (- depth 1))
                        (visible-dirs path))
                path)
    @[path]))

(defn git-projects [path depth]
  (filter git-project? (search-directories path depth)))

(defmacro repeat-map [n & body]
  ~(seq [_ :range [0 ,n]]
        (do ,;body)))

(defn pmap [f xs]
  (each el xs
    (thread/new
     |(:send $0 (f el))
     1
     :h))
  (repeat-map (length xs)
              (thread/receive 300)))

(defn run [& args]
  (let [buf @""
        status (first (sh/run* [;args :> buf :> [stderr stdout]]))]
    {:result (if (= 0 status) :success :error)
     :output (-> buf string/slice string/trimr)}))

(defn git-pull [dir]
  {:repo dir
   :pull (run "git" "-C" dir "pull")
   :branch (run "git" "-C" dir "rev-parse" "--abbrev-ref" "HEAD")})

(defn main [& args]
  (let [projects (git-projects "." 1)
        results (sort-by |($0 :repo) (pmap git-pull projects))]
    (each result results
      (let [{:repo repo
             :pull pull
             :branch branch} result]
        (print (color-result (pull :result) repo)
               (when (= :success (branch :result))
                 (string " (" (info (branch :output)) ")"))
               "\n"
               (indent (pull :output) 4)
               "\n")))))
