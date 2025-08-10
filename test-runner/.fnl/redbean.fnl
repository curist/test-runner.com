(local redbean
  { :argon2 {
   :hash_encoded (fn [pass salt config]
     "Hashes password.

This is consistent with the README of the reference implementation:

    >: assert(argon2.hash_encoded(\"password\", \"somesalt\", {
        variant = argon2.variants.argon2_i,
        hash_len = 24,
        t_cost = 2,
    }))


`salt` is a nonce value used to hash the string.

`config.m_cost` is the memory hardness in kibibytes, which defaults
to 4096 (4 mibibytes). It's recommended that this be tuned upwards.

`config.t_cost` is the number of iterations, which defaults to 3.

`config.parallelism` is the parallelism factor, which defaults to 1.

`config.hash_len` is the number of desired bytes in hash output,
which defaults to 32.

`config.variant` may be:

- `argon2.variants.argon2_id` blend of other two methods [default]
- `argon2.variants.argon2_i` maximize resistance to side-channel attacks
- `argon2.variants.argon2_d` maximize resistance to gpu cracking attacks

@param pass string
@param salt string
@param config argon2.Config
@return string ascii
@nodiscard
@overload fun(pass: string, salt: string, config?: argon2.Config): nil, error: string"
     (_G.argon2.hash_encoded pass salt config))
   :verify (fn [encoded pass]
     "Verifies password, e.g.

    >: argon2.verify(
        \"p=4$c29tZXNhbHQ$RdescudvJCsgt3ub+b+dWRWJTmaaJObG\",
    true

@param encoded string
@param pass string
@return boolean ok
@nodiscard
@overload fun(encoded: string, pass: string): nil, error: string"
     (_G.argon2.verify encoded pass))


   :_AUTHOR "Thibault Charbonnier"
   :_LICENSE "MIT"
   :_URL "https://github.com/thibaultcha/lua-argon2"
   :_VERSION "3.0.1"
  }

 :finger {
   :finger-syn (fn [syn_packet_bytes]
     "Fingerprints IP+TCP SYN packet.

This returns a hash-like magic number that reflects the SYN packet structure,
e.g. ordering of options, maximum segment size, etc. We make no guarantees this
hashing algorithm won't change as we learn more about the optimal way to
- fingerprint, so be sure to save your syn packets too if you're using this
feature, in case they need to be rehashed in the future.

This function is nil/error propagating.
@param syn_packet_bytes string
@return integer synfinger uint32
@nodiscard
@overload fun(syn_packet_bytes: string): nil, error: string
@overload fun(nil: nil, error?: string): nil, error: string?"
     (_G.finger.FingerSyn syn_packet_bytes))
   :get-syn-finger-os (fn [synfinger]
     "Fingerprints IP+TCP SYN packet.

If synfinger is a known hard-coded magic number, then one of the following
strings may be returned:

- `\"LINUX\"`
- `\"WINDOWS\"`
- `\"XNU\"`
- `\"NETBSD\"`
- `\"FREEBSD\"`
- `\"OPENBSD\"`

If this function returns `nil`, then one thing you can do to help is file an
issue and share with us your SYN packet specimens. The way we prefer to receive
them is in `EncodeLua(syn_packet_bytes)` format along with details on the
operating system which you must know.
@param synfinger integer
@return \"LINUX\"|\"WINDOWS\"|\"XNU\"|\"NETBSD\"|\"FREEBSD\"|\"OPENBSD\" osname
@nodiscard
@overload fun(synfinger: integer): nil, error: string"
     (_G.finger.GetSynFingerOs synfinger))
   :describe-syn (fn [syn_packet_bytes]
     "Describes IP+TCP SYN packet.

The layout looks as follows:

- `TTL:OPTIONS:WSIZE:MSS`

The `TTL`, `WSIZE`, and `MSS` fields are unsigned decimal fields.

The `OPTIONS` field communicates the ordering of the commonly used subset of
tcp options. The following character mappings are defined. TCP options not on
this list will be ignored.

- `E`: End of Option list
- `N`: No-Operation
- `M`: Maximum Segment Size
- `K`: Window Scale
- `O`: SACK Permitted
- `A`: SACK
- `e`: Echo (obsolete)
- `r`: Echo reply (obsolete)
- `T`: Timestamps

This function is nil/error propagating.
@param syn_packet_bytes string
@return string description
@nodiscard
@overload fun(syn_packet_bytes: string): nil, error: string
@overload fun(nil: nil, error?: string): nil, error: string?"
     (_G.finger.DescribeSyn syn_packet_bytes))


  }

 :lsqlite3 {
   :open (fn [filename flags]
     "Opens (or creates if it does not exist) an SQLite database with name filename
and returns its handle as userdata (the returned object should be used for all
further method calls in connection with this specific database, see Database
methods). Example:

    myDB = lsqlite3.open('MyDatabase.sqlite3')  -- open
    -- do some database calls...
    myDB:close()  -- close

In case of an error, the function returns `nil`, an error code and an error message.

Since `0.9.4`, there is a second optional `flags` argument to `lsqlite3.open`.
See https://www.sqlite.org/c3ref/open.html for an explanation of these flags and options.

    local db = lsqlite3.open('foo.db', lsqlite3.OPEN_READWRITE + lsqlite3.OPEN_CREATE + lsqlite3.OPEN_SHAREDCACHE)

@param filename string
@param flags? integer defaults to `lsqlite3.OPEN_READWRITE + lsqlite3.OPEN_CREATE`
@return lsqlite3.Database db
@nodiscard
@overload fun(filename: string, flags?: integer): nil, errorcode: integer, errormsg: string"
     (_G.lsqlite3.open filename flags))
   :open_memory (fn []
     "Opens an SQLite database in memory and returns its handle as userdata. In case
of an error, the function returns `nil`, an error code and an error message.
(In-memory databases are volatile as they are never stored on disk.)
@return lsqlite3.Database db
@nodiscard
@overload fun(): nil, errorcode: integer, errormsg: string"
     (_G.lsqlite3.open_memory ))
   :lversion (fn []
     "@return string version lsqlite3 library version information, in the form 'x.y[.z]'.
@nodiscard"
     (_G.lsqlite3.lversion ))
   :version (fn []
     "@return string version SQLite version information, in the form 'x.y[.z[.p]]'.
@nodiscard"
     (_G.lsqlite3.version ))


   :ABORT 4
   :ALTER_TABLE 26
   :ANALYZE 28
   :ATTACH 24
   :BLOB 4
   :BUSY 5
   :CANTOPEN 14
   :CHANGESETAPPLY_INVERT 2
   :CHANGESETAPPLY_NOSAVEPOINT 1
   :CHANGESETSTART_INVERT 2
   :CHANGESET_ABORT 2
   :CHANGESET_CONFLICT 3
   :CHANGESET_CONSTRAINT 4
   :CHANGESET_DATA 1
   :CHANGESET_FOREIGN_KEY 5
   :CHANGESET_NOTFOUND 2
   :CHANGESET_OMIT 0
   :CHANGESET_REPLACE 1
   :CHECKPOINT_FULL 1
   :CHECKPOINT_PASSIVE 0
   :CHECKPOINT_RESTART 2
   :CHECKPOINT_TRUNCATE 3
   :CONFIG_LOG 16
   :CONFIG_MULTITHREAD 2
   :CONFIG_SERIALIZED 3
   :CONFIG_SINGLETHREAD 1
   :CONSTRAINT 19
   :CORRUPT 11
   :CREATE_INDEX 1
   :CREATE_TABLE 2
   :CREATE_TEMP_INDEX 3
   :CREATE_TEMP_TABLE 4
   :CREATE_TEMP_TRIGGER 5
   :CREATE_TEMP_VIEW 6
   :CREATE_TRIGGER 7
   :CREATE_VIEW 8
   :CREATE_VTABLE 29
   :DELETE 9
   :DETACH 25
   :DONE 101
   :DROP_INDEX 10
   :DROP_TABLE 11
   :DROP_TEMP_INDEX 12
   :DROP_TEMP_TABLE 13
   :DROP_TEMP_TRIGGER 14
   :DROP_TEMP_VIEW 15
   :DROP_TRIGGER 16
   :DROP_VIEW 17
   :DROP_VTABLE 30
   :EMPTY 16
   :ERROR 1
   :FLOAT 2
   :FORMAT 24
   :FULL 13
   :FUNCTION 31
   :INSERT 18
   :INTEGER 1
   :INTERNAL 2
   :INTERRUPT 9
   :IOERR 10
   :LOCKED 6
   :MISMATCH 20
   :MISUSE 21
   :NOLFS 22
   :NOMEM 7
   :NOTADB 26
   :NOTFOUND 12
   :NULL 5
   :OK 0
   :OPEN_CREATE 4
   :OPEN_FULLMUTEX 65536
   :OPEN_MEMORY 128
   :OPEN_NOMUTEX 32768
   :OPEN_PRIVATECACHE 262144
   :OPEN_READONLY 1
   :OPEN_READWRITE 2
   :OPEN_SHAREDCACHE 131072
   :OPEN_URI 64
   :PERM 3
   :PRAGMA 19
   :PROTOCOL 15
   :RANGE 25
   :READ 20
   :READONLY 8
   :REINDEX 27
   :ROW 100
   :SAVEPOINT 32
   :SCHEMA 17
   :SELECT 21
   :TEXT 3
   :TOOBIG 18
   :TRANSACTION 22
   :UPDATE 23
  }

 :maxmind {
   :open (fn [filepath]
     "@param filepath string the location of the MaxMind database
@return maxmind.Db db
@nodiscard"
     (_G.maxmind.open filepath))


  }

 :path {
   :dirname (fn [str]
     "Strips final component of path, e.g.

    path      │ dirname
    ───────────────────
    .         │ .
    ..        │ .
    /         │ /
    usr       │ .
    /usr/     │ /
    /usr/lib  │ /usr
    /usr/lib/ │ /usr
@param str string
@return string
@nodiscard"
     (_G.path.dirname str))
   :basename (fn [str]
     "Returns final component of path, e.g.

    path      │ basename
    ─────────────────────
    .         │ .
    ..        │ ..
    /         │ /
    usr       │ usr
    /usr/     │ usr
    /usr/lib  │ lib
    /usr/lib/ │ lib
@param str string
@return string
@nodiscard"
     (_G.path.basename str))
   :join (fn [...]
     "Concatenates path components, e.g.

    x         │ y        │ joined
    ─────────────────────────────────
    /         │ /        │ /
    /usr      │ lib      │ /usr/lib
    /usr/     │ lib      │ /usr/lib
    /usr/lib  │ /lib     │ /lib

You may specify 1+ arguments.

Specifying no arguments will raise an error. If `nil` arguments are specified,
then they're skipped over. If exclusively `nil` arguments are passed, then `nil`
is returned. Empty strings behave similarly to `nil`, but unlike `nil` may
coerce a trailing slash.
@param str string?
@param ... string?
@return string?
@nodiscard"
     (_G.path.join ...))
   :exists (fn [path]
     "Returns `true` if path exists.
This function is inclusive of regular files, directories, and special files.
Symbolic links are followed are resolved. On error, `false` is returned.
@param path string
@return boolean
@nodiscard"
     (_G.path.exists path))
   :isfile (fn [path]
     "Returns `true` if path exists and is regular file.
Symbolic links are not followed. On error, `false` is returned.
@param path string
@return boolean
@nodiscard"
     (_G.path.isfile path))
   :isdir (fn [path]
     "Returns `true` if path exists and is directory.
Symbolic links are not followed. On error, `false` is returned.
@param path string
@return boolean
@nodiscard"
     (_G.path.isdir path))
   :islink (fn [path]
     "Returns `true` if path exists and is symbolic link.
Symbolic links are not followed. On error, `false` is returned.
@param path string
@return boolean
@nodiscard"
     (_G.path.islink path))


  }

 :re {
   :search (fn [regex text flags]
     "Searches for regular expression match in text.

This is a shorthand notation roughly equivalent to:

    preg = re.compile(regex)
    patt = preg:search(re, text)

@param regex string
@param text string
@param flags integer? defaults to zero and may have any of:

- `re.BASIC`
- `re.ICASE`
- `re.NEWLINE`
- `re.NOSUB`
- `re.NOTBOL`
- `re.NOTEOL`

This has exponential complexity. Please use `re.compile()` to compile your regular expressions once from `/.init.lua`. This API exists for convenience. This isn't recommended for prod.

This uses POSIX extended syntax by default.
@return string match, string ... the match, followed by any captured groups
@nodiscard
@overload fun(regex: string, text: string, flags?: integer): nil, error: re.Errno"
     (_G.re.search regex text flags))
   :compile (fn [regex flags]
     "Compiles regular expression.

@param regex string
@param flags integer? defaults to zero and may have any of:

- `re.BASIC`
- `re.ICASE`
- `re.NEWLINE`
- `re.NOSUB`

This has an O(2^𝑛) cost. Consider compiling regular expressions once
from your `/.init.lua` file.

If regex is an untrusted user value, then `unix.setrlimit` should be
used to impose cpu and memory quotas for security.

This uses POSIX extended syntax by default.
@return re.Regex
@nodiscard
@overload fun(regex: string, flags?: integer): nil, error: re.Errno"
     (_G.re.compile regex flags))


   :BADBR 10
   :BADPAT 2
   :BADRPT 13
   :BASIC 1
   :EBRACE 9
   :EBRACK 7
   :ECOLLATE 3
   :ECTYPE 4
   :EESCAPE 5
   :EPAREN 8
   :ERANGE 11
   :ESPACE 12
   :ESUBREG 6
   :ICASE 2
   :NEWLINE 4
   :NOMATCH 1
   :NOSUB 8
   :NOTBOL 256
   :NOTEOL 512
  }

 :unix {
   :open (fn [path flags mode dirfd]
     "Opens file.

Returns a file descriptor integer that needs to be closed, e.g.

    fd = assert(unix.open(\"/etc/passwd\", unix.O_RDONLY))
    print(unix.read(fd))
    unix.close(fd)

`flags` should have one of:

- `O_RDONLY`:     open for reading (default)
- `O_WRONLY`:     open for writing
- `O_RDWR`:       open for reading and writing

The following values may also be OR'd into `flags`:

 - `O_CREAT`      create file if it doesn't exist
 - `O_TRUNC`      automatic ftruncate(fd,0) if exists
 - `O_CLOEXEC`    automatic close() upon execve()
 - `O_EXCL`       exclusive access (see below)
 - `O_APPEND`     open file for append only
 - `O_NONBLOCK`   asks read/write to fail with EAGAIN rather than block
 - `O_DIRECT`     it's complicated (not supported on Apple and OpenBSD)
 - `O_DIRECTORY`  useful for stat'ing (hint on UNIX but required on NT)
 - `O_TMPFILE`    try to make temp more secure (Linux and Windows only)
 - `O_NOFOLLOW`   fail if it's a symlink (zero on Windows)
 - `O_DSYNC`      it's complicated (zero on non-Linux/Apple)
 - `O_RSYNC`      it's complicated (zero on non-Linux/Apple)
 - `O_PATH`       it's complicated (zero on non-Linux)
 - `O_VERIFY`     it's complicated (zero on non-FreeBSD)
 - `O_SHLOCK`     it's complicated (zero on non-BSD)
 - `O_EXLOCK`     it's complicated (zero on non-BSD)
 - `O_NOATIME`    don't record access time (zero on non-Linux)
 - `O_RANDOM`     hint random access intent (zero on non-Windows)
 - `O_SEQUENTIAL` hint sequential access intent (zero on non-Windows)
 - `O_COMPRESSED` ask fs to abstract compression (zero on non-Windows)
 - `O_INDEXED`    turns on that slow performance (zero on non-Windows)

 There are three regular combinations for the above flags:

 - `O_RDONLY`: Opens existing file for reading. If it doesn't exist
   then nil is returned and errno will be `ENOENT` (or in some other
   cases `ENOTDIR`).

 - `O_WRONLY|O_CREAT|O_TRUNC`: Creates file. If it already exists,
   then the existing copy is destroyed and the opened file will
   start off with a length of zero. This is the behavior of the
   traditional creat() system call.

 - `O_WRONLY|O_CREAT|O_EXCL`: Create file only if doesn't exist
   already. If it does exist then `nil` is returned along with
   `errno` set to `EEXIST`.

`dirfd` defaults to to `unix.AT_FDCWD` and may optionally be set to
a directory file descriptor to which `path` is relative.

Returns `ENOENT` if `path` doesn't exist.

Returns `ENOTDIR` if `path` contained a directory component that
wasn't a directory
.
@param path string
@param flags integer
@param mode integer?
@param dirfd integer?
@return integer fd
@nodiscard
@overload fun(path: string, flags: integer, mode?: integer, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.open path flags mode dirfd))
   :close (fn [fd]
     "Closes file descriptor.

This function should never be called twice for the same file
descriptor, regardless of whether or not an error happened. The file
descriptor is always gone after close is called. So it technically
always succeeds, but that doesn't mean an error should be ignored.
For example, on NFS a close failure could indicate data loss.

Closing does not mean that scheduled i/o operations have been
completed. You'd need to use fsync() or fdatasync() beforehand to
ensure that. You shouldn't need to do that normally, because our
close implementation guarantees a consistent view, since on systems
where it isn't guaranteed (like Windows) close will implicitly sync.

File descriptors are automatically closed on exit().

Returns `EBADF` if `fd` wasn't valid.

Returns `EINTR` possibly maybe.

Returns `EIO` if an i/o error occurred.
@param fd integer
@return true
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.close fd))
   :read (fn [fd bufsiz offset]
     "Reads from file descriptor.

This function returns empty string on end of file. The exception is
if `bufsiz` is zero, in which case an empty returned string means
the file descriptor works.
@param fd integer
@param bufsiz string?
@param offset integer?
@return string data
@overload fun(fd: integer, bufsiz?: string, offset?: integer): nil, error: unix.Errno"
     (_G.unix.read fd bufsiz offset))
   :write (fn [fd data offset]
     "Writes to file descriptor.
@param fd integer
@param data string
@param offset integer?
@return integer wrotebytes
@overload fun(fd: integer, data: string, offset?: integer): nil, error: unix.Errno"
     (_G.unix.write fd data offset))
   :exit (fn [exitcode]
     "Invokes `_Exit(exitcode)` on the process. This will immediately
halt the current process. Memory will be freed. File descriptors
will be closed. Any open connections it owns will be reset. This
function never returns.
@param exitcode integer?"
     (_G.unix.exit exitcode))
   :environ (fn []
     "Returns raw environment variables.

This allocates and constructs the C/C++ `environ` variable as a Lua
table consisting of string keys and string values.

This data structure preserves casing. On Windows NT, by convention,
environment variable keys are treated in a case-insensitive way. It
is the responsibility of the caller to consider this.

This data structure preserves valueless variables. It's possible on
both UNIX and Windows to have an environment variable without an
equals, even though it's unusual.

This data structure preserves duplicates. For example, on Windows,
there's some irregular uses of environment variables such as how the
command prompt inserts multiple environment variables with empty
string as keys, for its internal bookkeeping.

@return table<string, string?>
@nodiscard"
     (_G.unix.environ ))
   :fork (fn []
     "Creates a new process mitosis style.

This system call returns twice. The parent process gets the nonzero
pid. The child gets zero.

Here's a simple usage example of creating subprocesses, where we
fork off a child worker from a main process hook callback to do some
independent chores, such as sending an HTTP request back to redbean.

   -- as soon as server starts, make a fetch to the server
   -- then signal redbean to shutdown when fetch is complete
   local onServerStart = function()
      if assert(unix.fork()) == 0 then
         local ok, headers, body = Fetch('http://127.0.0.1:8080/test')
         unix.kill(unix.getppid(), unix.SIGTERM)
         unix.exit(0)
      end
   end
   OnServerStart = onServerStart

We didn't need to use `wait()` here, because (a) we want redbean to go
back to what it was doing before as the `Fetch()` completes, and (b)
redbean's main process already has a zombie collector. However it's
a moot point, since once the fetch is done, the child process then
asks redbean to gracefully shutdown by sending SIGTERM its parent.

This is actually a situation where we *must* use fork, because the
purpose of the main redbean process is to call accept() and create
workers. So if we programmed redbean to use the main process to send
a blocking request to itself instead, then redbean would deadlock
and never be able to accept() the client.

While deadlocking is an extreme example, the truth is that latency
issues can crop up for the same reason that just cause jitter
instead, and as such, can easily go unnoticed. For example, if you
do soemething that takes longer than a few milliseconds from inside
your redbean heartbeat, then that's a few milliseconds in which
redbean is no longer concurrent, and tail latency is being added to
its ability to accept new connections. fork() does a great job at
solving this.

If you're not sure how long something will take, then when in doubt,
fork off a process. You can then report its completion to something
like SQLite. Redbean makes having lots of processes cheap. On Linux
they're about as lightweight as what heavyweight environments call
greenlets. You can easily have 10,000 Redbean workers on one PC.

Here's some benchmarks for fork() performance across platforms:

   Linux 5.4 fork      l:     97,200𝑐    31,395𝑛𝑠  [metal]
   FreeBSD 12 fork     l:    236,089𝑐    78,841𝑛𝑠  [vmware]
   Darwin 20.6 fork    l:    295,325𝑐    81,738𝑛𝑠  [metal]
   NetBSD 9 fork       l:  5,832,027𝑐 1,947,899𝑛𝑠  [vmware]
   OpenBSD 6.8 fork    l: 13,241,940𝑐 4,422,103𝑛𝑠  [vmware]
   Windows10 fork      l: 18,802,239𝑐 6,360,271𝑛𝑠  [metal]

One of the benefits of using `fork()` is it creates an isolation
barrier between the different parts of your app. This can lead to
enhanced reliability and security. For example, redbean uses fork so
it can wipe your ssl keys from memory before handing over control to
request handlers that process untrusted input. It also ensures that
if your Lua app crashes, it won't take down the server as a whole.
Hence it should come as no surprise that `fork()` would go slower on
operating systems that have more security features. So depending on
your use case, you can choose the operating system that suits you.

@return integer|0 childpid
@overload fun(): nil, error: unix.Errno"
     (_G.unix.fork ))
   :commandv (fn [prog]
     "Performs `$PATH` lookup of executable.

    unix = require 'unix'
    prog = assert(unix.commandv('ls'))
    unix.execve(prog, {prog, '-hal', '.'}, {'PATH=/bin'})
    unix.exit(127)

If `prog` is an absolute path, then it's returned as-is. If `prog`
contains slashes then it's not path searched either and will be
returned if it exists. On Windows, it's recommended that you install
programs from cosmos to c:/bin/ without any .exe or .com suffix, so
they can be discovered like they would on UNIX. If you want to find
a program like notepad on the $PATH using this function, then you
need to specify \"notepad.exe\" so it includes the extension.

@param prog string
@return string path
@overload fun(prog: string): nil, error: unix.Errno"
     (_G.unix.commandv prog))
   :execve (fn [prog args env]
     "Exits current process, replacing it with a new instance of the
specified program. `prog` needs to be an absolute path, see
commandv(). `env` defaults to to the current `environ`. Here's
a basic usage example:

    unix.execve(\"/bin/ls\", {\"/bin/ls\", \"-hal\"}, {\"PATH=/bin\"})
    unix.exit(127)

`prog` needs to be the resolved pathname of your executable. You
can use commandv() to search your `PATH`.

`args` is a string list table. The first element in `args`
should be `prog`. Values are coerced to strings. This parameter
defaults to `{prog}`.

`env` is a string list table. Values are coerced to strings. No
ordering requirement is imposed. By convention, each string has its
key and value divided by an equals sign without spaces. If this
parameter is not specified, it'll default to the C/C++ `environ`
variable which is inherited from the shell that launched redbean.
It's the responsibility of the user to supply a sanitized environ
when spawning untrusted processes.

`execve()` is normally called after `fork()` returns `0`. If that isn't
the case, then your redbean worker will be destroyed.

This function never returns on success.

`EAGAIN` is returned if you've enforced a max number of
processes using `setrlimit(RLIMIT_NPROC)`.

@param prog string
@param args string[]
@param env string[]
@return nil, unix.Errno error
@overload fun(prog: string): nil, error: unix.Errno"
     (_G.unix.execve prog args env))
   :dup (fn [oldfd newfd flags lowest]
     "Duplicates file descriptor.

`newfd` may be specified to choose a specific number for the new
file descriptor. If it's already open, then the preexisting one will
be silently closed. `EINVAL` is returned if `newfd` equals `oldfd`.

`flags` can have `O_CLOEXEC` which means the returned file
descriptors will be automatically closed upon execve().

`lowest` defaults to zero and defines the lowest numbered file
descriptor that's acceptable to use. If `newfd` is specified then
`lowest` is ignored. For example, if you wanted to duplicate
standard input, then:

    stdin2 = assert(unix.dup(0, nil, unix.O_CLOEXEC, 3))

Will ensure that, in the rare event standard output or standard
error are closed, you won't accidentally duplicate standard input to
those numbers.

@param oldfd integer
@param newfd integer?
@param flags integer?
@param lowest integer?
@return integer newfd
@overload fun(oldfd: integer, newfd?: integer, flags?: integer, lowest?: integer): nil, error: unix.Errno"
     (_G.unix.dup oldfd newfd flags lowest))
   :pipe (fn [flags]
     "Creates fifo which enables communication between processes.

@param flags integer? may have any combination (using bitwise OR) of:

- `O_CLOEXEC`: Automatically close file descriptor upon execve()

- `O_NONBLOCK`: Request `EAGAIN` be raised rather than blocking

- `O_DIRECT`: Enable packet mode w/ atomic reads and writes, so long
  as they're no larger than `PIPE_BUF` (guaranteed to be 512+ bytes)
  with support limited to Linux, Windows NT, FreeBSD, and NetBSD.

Returns two file descriptors: one for reading and one for writing.

Here's an example of how pipe(), fork(), dup(), etc. may be used
to serve an HTTP response containing the output of a subprocess.

    local unix = require \"unix\"
    ls = assert(unix.commandv(\"ls\"))
    reader, writer = assert(unix.pipe())
    if assert(unix.fork()) == 0 then
       unix.close(1)
       unix.dup(writer)
       unix.close(writer)
       unix.close(reader)
       unix.execve(ls, {ls, \"-Shal\"})
       unix.exit(127)
    else
       unix.close(writer)
       SetHeader('Content-Type', 'text/plain')
       while true do
          data, err = unix.read(reader)
          if data then
             if data ~= \"\" then
                Write(data)
             else
                break
             end
          elseif err:errno() ~= EINTR then
             Log(kLogWarn, tostring(err))
             break
          end
       end
       assert(unix.close(reader))
       assert(unix.wait())
    end

@return integer reader, integer writer
@nodiscard
@overload fun(flags?: integer): nil, error: unix.Errno"
     (_G.unix.pipe flags))
   :wait (fn [pid options]
     "Waits for subprocess to terminate.

`pid` defaults to `-1` which means any child process. Setting
`pid` to `0` is equivalent to `-getpid()`. If `pid < -1` then
that means wait for any pid in the process group `-pid`. Then
lastly if `pid > 0` then this waits for a specific process id

Options may have `WNOHANG` which means don't block, check for
the existence of processes that are already dead (technically
speaking zombies) and if so harvest them immediately.

Returns the process id of the child that terminated. In other
cases, the returned `pid` is nil and `errno` is non-nil.

The returned `wstatus` contains information about the process
exit status. It's a complicated integer and there's functions
that can help interpret it. For example:

    -- wait for zombies
    -- traditional technique for SIGCHLD handlers
    while true do
       pid, status = unix.wait(-1, unix.WNOHANG)
       if pid then
          if unix.WIFEXITED(status) then
             print('child', pid, 'exited with',
                   unix.WEXITSTATUS(status))
          elseif unix.WIFSIGNALED(status) then
             print('child', pid, 'crashed with',
                   unix.strsignal(unix.WTERMSIG(status)))
          end
       elseif status:errno() == unix.ECHILD then
          Log(kLogDebug, 'no more zombies')
          break
       else
          Log(kLogWarn, tostring(err))
          break
       end
    end

@param pid? integer
@param options? integer
@return integer pid, integer wstatus, unix.Rusage rusage
@overload fun(pid?: integer, options?: integer): nil, error: unix.Errno"
     (_G.unix.wait pid options))
   :WIFEXITED (fn [wstatus]
     "Returns `true` if process exited cleanly.
@param wstatus integer
@return boolean
@nodiscard"
     (_G.unix.WIFEXITED wstatus))
   :WEXITSTATUS (fn [wstatus]
     "Returns code passed to exit() assuming `WIFEXITED(wstatus)` is true.
@param wstatus integer
@return integer exitcode uint8
@nodiscard"
     (_G.unix.WEXITSTATUS wstatus))
   :WIFSIGNALED (fn [wstatus]
     "Returns `true` if process terminated due to a signal.
@param wstatus integer
@return boolean
@nodiscard"
     (_G.unix.WIFSIGNALED wstatus))
   :WTERMSIG (fn [wstatus]
     "Returns signal that caused process to terminate assuming
`WIFSIGNALED(wstatus)` is `true`.
@param wstatus integer
@return integer sig uint8
@nodiscard"
     (_G.unix.WTERMSIG wstatus))
   :getpid (fn []
     "Returns process id of current process.

This function does not fail.
@return integer pid
@nodiscard"
     (_G.unix.getpid ))
   :getppid (fn []
     "Returns process id of parent process.

This function does not fail.
@return integer pid
@nodiscard"
     (_G.unix.getppid ))
   :kill (fn [pid sig]
     "Sends signal to process(es).

The impact of this action can be terminating the process, or
interrupting it to request something happen.

`pid` can be:

- `pid > 0` signals one process by id
- `== 0`    signals all processes in current process group
- `-1`      signals all processes possible (except init)
- `< -1`    signals all processes in -pid process group

`sig` can be:

- `0`       checks both if pid exists and we can signal it
- `SIGINT`  sends ctrl-c keyboard interrupt
- `SIGQUIT` sends backtrace and exit signal
- `SIGTERM` sends shutdown signal
- etc.

Windows NT only supports the kill() signals required by the ANSI C89
standard, which are `SIGINT` and `SIGQUIT`. All other signals on the
Windows platform that are sent to another process via kill() will be
treated like `SIGKILL`.
@param pid integer
@param sig integer
@return true
@overload fun(pid: integer, sid: integer): nil, error: unix.Errno"
     (_G.unix.kill pid sig))
   :raise (fn [sig]
     "Triggers signal in current process.

This is pretty much the same as `kill(getpid(), sig)`.
@param sig integer
@return integer rc
@overload fun(sig: integer): nil, error: unix.Errno"
     (_G.unix.raise sig))
   :access (fn [path how flags dirfd]
     "Checks if effective user of current process has permission to access file.
@param path string
@param how integer can be `R_OK`, `W_OK`, `X_OK`, or `F_OK` to check for read, write, execute, and existence respectively.
@param flags? integer may have any of:
- `AT_SYMLINK_NOFOLLOW`: do not follow symbolic links.
@param dirfd? integer
@return true
@overload fun(path: string, how: integer, flags?: integer, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.access path how flags dirfd))
   :mkdir (fn [path mode dirfd]
     "Makes directory.

`path` is the path of the directory you wish to create.

`mode` is octal permission bits, e.g. `0755`.

Fails with `EEXIST` if `path` already exists, whether it be a
directory or a file.

Fails with `ENOENT` if the parent directory of the directory you
want to create doesn't exist. For making `a/really/long/path/`
consider using makedirs() instead.

Fails with `ENOTDIR` if a parent directory component existed that
wasn't a directory.

Fails with `EACCES` if the parent directory doesn't grant write
permission to the current user.

Fails with `ENAMETOOLONG` if the path is too long.

@param path string
@param mode? integer
@param dirfd? integer
@return true
@overload fun(path: string, mode?: integer, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.mkdir path mode dirfd))
   :makedirs (fn [path mode]
     "Unlike mkdir() this convenience wrapper will automatically create
parent parent directories as needed. If the directory already exists
then, unlike mkdir() which returns EEXIST, the makedirs() function
will return success.

`path` is the path of the directory you wish to create.

`mode` is octal permission bits, e.g. `0755`.

@param path string
@param mode? integer
@return true
@overload fun(path: string, mode?: integer): nil, error: unix.Errno"
     (_G.unix.makedirs path mode))
   :chdir (fn [path]
     "Changes current directory to `path`.
@param path string
@return true
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.chdir path))
   :unlink (fn [path dirfd]
     "Removes file at `path`.

If `path` refers to a symbolic link, the link is removed.

Returns `EISDIR` if `path` refers to a directory. See `rmdir()`.

@param path string
@param dirfd? integer
@return true
@overload fun(path: string, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.unlink path dirfd))
   :rmdir (fn [path dirfd]
     "Removes empty directory at `path`.

Returns `ENOTDIR` if `path` isn't a directory, or a path component
in `path` exists yet wasn't a directory.

@param path string
@param dirfd? integer
@return true
@overload fun(path: string, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.rmdir path dirfd))
   :rename (fn [oldpath newpath olddirfd newdirfd]
     "Renames file or directory.
@param oldpath string
@param newpath string
@param olddirfd integer
@param newdirfd integer
@return true
@overload fun(oldpath: string, newpath: string): true
@overload fun(oldpath: string, newpath: string, olddirfd: integer, newdirfd: integer): nil, error: unix.Errno
@overload fun(oldpath: string, newpath: string): nil, error: unix.Errno"
     (_G.unix.rename oldpath newpath olddirfd newdirfd))
   :link (fn [existingpath newpath flags olddirfd newdirfd]
     "Creates hard link, so your underlying inode has two names.
@param existingpath string
@param newpath string
@param flags integer
@param olddirfd integer
@param newdirfd integer
@return true
@overload fun(existingpath: string, newpath: string, flags?: integer): true
@overload fun(existingpath: string, newpath: string, flags?: integer): nil, error: unix.Errno
@overload fun(existingpath: string, newpath: string, flags: integer, olddirfd: integer, newdirfd: integer): true
@overload fun(existingpath: string, newpath: string, flags: integer, olddirfd: integer, newdirfd: integer): nil, error: unix.Errno"
     (_G.unix.link existingpath newpath flags olddirfd newdirfd))
   :symlink (fn [target linkpath newdirfd]
     "Creates symbolic link.

On Windows NT a symbolic link is called a \"reparse point\" and can
only be created from an administrator account. Your redbean will
automatically request the appropriate permissions.
@param target string
@param linkpath string
@param newdirfd? integer
@return true
@overload fun(target: string, linkpath: string, newdirfd?: integer): nil, error: unix.Errno"
     (_G.unix.symlink target linkpath newdirfd))
   :readlink (fn [path dirfd]
     "Reads contents of symbolic link.

Note that broken links are supported on all platforms. A symbolic
link can contain just about anything. It's important to not assume
that `content` will be a valid filename.

On Windows NT, this function transliterates `\\` to `/` and
furthermore prefixes `//?/` to WIN32 DOS-style absolute paths,
thereby assisting with simple absolute filename checks in addition
to enabling one to exceed the traditional 260 character limit.
@param path string
@param dirfd? integer
@return string content
@nodiscard
@overload fun(path: string, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.readlink path dirfd))
   :realpath (fn [path]
     "Returns absolute path of filename, with `.` and `..` components
removed, and symlinks will be resolved.
@param path string
@return string path
@nodiscard
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.realpath path))
   :utimensat (fn [path asecs ananos msecs mnanos dirfd flags]
     "Changes access and/or modified timestamps on file.

`path` is a string with the name of the file.

The `asecs` and `ananos` parameters set the access time. If they're
none or nil, the current time will be used.

The `msecs` and `mnanos` parameters set the modified time. If
they're none or nil, the current time will be used.

The nanosecond parameters (`ananos` and `mnanos`) must be on the
interval [0,1000000000) or `unix.EINVAL` is raised. On XNU this is
truncated to microsecond precision. On Windows NT, it's truncated to
hectonanosecond precision. These nanosecond parameters may also be
set to one of the following special values:

- `unix.UTIME_NOW`: Fill this timestamp with current time. This
feature is not available on old versions of Linux, e.g. RHEL5.

- `unix.UTIME_OMIT`: Do not alter this timestamp. This feature is
not available on old versions of Linux, e.g. RHEL5.

`dirfd` is a file descriptor integer opened with `O_DIRECTORY`
that's used for relative path names. It defaults to `unix.AT_FDCWD`.

`flags` may have have any of the following flags bitwise or'd

- `AT_SYMLINK_NOFOLLOW`: Do not follow symbolic links. This makes it
possible to edit the timestamps on the symbolic link itself,
rather than the file it points to.

@param path string
@param asecs integer
@param ananos integer
@param msecs integer
@param mnanos integer
@param dirfd? integer
@param flags? integer
@return 0
@overload fun(path: string): 0
@overload fun(path: string, asecs: integer, ananos: integer, msecs: integer, mnanos: integer, dirfd?: integer, flags?: integer): nil, error: unix.Errno
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.utimensat path asecs ananos msecs mnanos dirfd flags))
   :futimens (fn [fd asecs ananos msecs mnanos]
     "Changes access and/or modified timestamps on file descriptor.

`fd` is the file descriptor of a file opened with `unix.open`.

The `asecs` and `ananos` parameters set the access time. If they're
none or nil, the current time will be used.

The `msecs` and `mnanos` parameters set the modified time. If
they're none or nil, the current time will be used.

The nanosecond parameters (`ananos` and `mnanos`) must be on the
interval [0,1000000000) or `unix.EINVAL` is raised. On XNU this is
truncated to microsecond precision. On Windows NT, it's truncated to
hectonanosecond precision. These nanosecond parameters may also be
set to one of the following special values:

- `unix.UTIME_NOW`: Fill this timestamp with current time.

- `unix.UTIME_OMIT`: Do not alter this timestamp.

This system call is currently not available on very old versions of
Linux, e.g. RHEL5.

@param fd integer
@param asecs integer
@param ananos integer
@param msecs integer
@param mnanos integer
@return 0
@overload fun(fd: integer): 0
@overload fun(fd: integer, asecs: integer, ananos: integer, msecs: integer, mnanos: integer): nil, error: unix.Errno
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.futimens fd asecs ananos msecs mnanos))
   :chown (fn [path uid gid flags dirfd]
     "Changes user and group on file.

Returns `ENOSYS` on Windows NT.
@param path string
@param uid integer
@param gid integer
@param flags? integer
@param dirfd? integer
@return true
@overload fun(path: string, uid: integer, gid: integer, flags?: integer, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.chown path uid gid flags dirfd))
   :chmod (fn [path mode flags dirfd]
     "Changes mode bits on file.

On Windows NT the chmod system call only changes the read-only
status of a file.
@param path string
@param mode integer
@param flags? integer
@param dirfd? integer
@return true
@overload fun(path: string, mode: integer, flags?: integer, dirfd?: integer): nil, error: unix.Errno"
     (_G.unix.chmod path mode flags dirfd))
   :getcwd (fn []
     "Returns current working directory.

On Windows NT, this function transliterates `\\` to `/` and
furthermore prefixes `//?/` to WIN32 DOS-style absolute paths,
thereby assisting with simple absolute filename checks in addition
to enabling one to exceed the traditional 260 character limit.
@return string path
@nodiscard
@overload fun(): nil, error: unix.Errno"
     (_G.unix.getcwd ))
   :rmrf (fn [path]
     "Recursively removes filesystem path.

Like `unix.makedirs()` this function isn't actually a system call but
rather is a Libc convenience wrapper. It's intended to be equivalent
to using the UNIX shell's `rm -rf path` command.

@param path string the file or directory path you wish to destroy.
@return true
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.rmrf path))
   :fcntl (fn [...]
     "Manipulates file descriptor.

`cmd` may be one of:

- `unix.F_GETFD` Returns file descriptor flags.
- `unix.F_SETFD` Sets file descriptor flags.
- `unix.F_GETFL` Returns file descriptor status flags.
- `unix.F_SETFL` Sets file descriptor status flags.
- `unix.F_SETLK` Acquires lock on file interval.
- `unix.F_SETLKW` Waits for lock on file interval.
- `unix.F_GETLK` Acquires information about lock.

unix.fcntl(fd:int, unix.F_GETFD)
    ├─→ flags:int
    └─→ nil, unix.Errno

  Returns file descriptor flags.

  The returned `flags` may include any of:

  - `unix.FD_CLOEXEC` if `fd` was opened with `unix.O_CLOEXEC`.

  Returns `EBADF` if `fd` isn't open.

unix.fcntl(fd:int, unix.F_SETFD, flags:int)
    ├─→ true
    └─→ nil, unix.Errno

  Sets file descriptor flags.

  `flags` may include any of:

  - `unix.FD_CLOEXEC` to re-open `fd` with `unix.O_CLOEXEC`.

  Returns `EBADF` if `fd` isn't open.

unix.fcntl(fd:int, unix.F_GETFL)
    ├─→ flags:int
    └─→ nil, unix.Errno

  Returns file descriptor status flags.

  `flags & unix.O_ACCMODE` includes one of:

  - `O_RDONLY`
  - `O_WRONLY`
  - `O_RDWR`

  Examples of values `flags & ~unix.O_ACCMODE` may include:

  - `O_NONBLOCK`
  - `O_APPEND`
  - `O_SYNC`
  - `O_ASYNC`
  - `O_NOATIME` on Linux
  - `O_RANDOM` on Windows
  - `O_SEQUENTIAL` on Windows
  - `O_DIRECT` on Linux/FreeBSD/NetBSD/Windows

  Examples of values `flags & ~unix.O_ACCMODE` won't include:

  - `O_CREAT`
  - `O_TRUNC`
  - `O_EXCL`
  - `O_NOCTTY`

  Returns `EBADF` if `fd` isn't open.

unix.fcntl(fd:int, unix.F_SETFL, flags:int)
    ├─→ true
    └─→ nil, unix.Errno

  Changes file descriptor status flags.

  Examples of values `flags` may include:

  - `O_NONBLOCK`
  - `O_APPEND`
  - `O_SYNC`
  - `O_ASYNC`
  - `O_NOATIME` on Linux
  - `O_RANDOM` on Windows
  - `O_SEQUENTIAL` on Windows
  - `O_DIRECT` on Linux/FreeBSD/NetBSD/Windows

  These values should be ignored:

  - `O_RDONLY`, `O_WRONLY`, `O_RDWR`
  - `O_CREAT`, `O_TRUNC`, `O_EXCL`
  - `O_NOCTTY`

  Returns `EBADF` if `fd` isn't open.

unix.fcntl(fd:int, unix.F_SETLK[, type[, start[, len[, whence]]]])
unix.fcntl(fd:int, unix.F_SETLKW[, type[, start[, len[, whence]]]])
    ├─→ true
    └─→ nil, unix.Errno

  Acquires lock on file interval.

  POSIX Advisory Locks allow multiple processes to leave voluntary
  hints to each other about which portions of a file they're using.

  The command may be:

  - `F_SETLK` to acquire lock if possible
  - `F_SETLKW` to wait for lock if necessary

  `fd` is file descriptor of open() file.

  `type` may be one of:

  - `F_RDLCK` for read lock (default)
  - `F_WRLCK` for read/write lock
  - `F_UNLCK` to unlock

  `start` is 0-indexed byte offset into file. The default is zero.

  `len` is byte length of interval. Zero is the default and it means
  until the end of the file.

  `whence` may be one of:

  - `SEEK_SET` start from beginning (default)
  - `SEEK_CUR` start from current position
  - `SEEK_END` start from end

  Returns `EAGAIN` if lock couldn't be acquired. POSIX says this
  theoretically could also be `EACCES` but we haven't seen this
  behavior on any of our supported platforms.

  Returns `EBADF` if `fd` wasn't open.

unix.fcntl(fd:int, unix.F_GETLK[, type[, start[, len[, whence]]]])
    ├─→ unix.F_UNLCK
    ├─→ type, start, len, whence, pid
    └─→ nil, unix.Errno

  Acquires information about POSIX advisory lock on file.

  This function accepts the same parameters as fcntl(F_SETLK) and
  tells you if the lock acquisition would be successful for a given
  range of bytes. If locking would have succeeded, then F_UNLCK is
  returned. If the lock would not have succeeded, then information
  about a conflicting lock is returned.

  Returned `type` may be `F_RDLCK` or `F_WRLCK`.

  Returned `pid` is the process id of the current lock owner.

  This function is currently not supported on Windows.

  Returns `EBADF` if `fd` wasn't open.

@param fd integer
@param cmd integer
@param ... any
@return any ...
@overload fun(fd: integer, unix.F_GETFD: integer): flags: integer
@overload fun(fd: integer, unix.F_GETFD: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_SETFD: integer, flags: integer): true
@overload fun(fd: integer, unix.F_SETFD: integer, flags: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_GETFL: integer): flags: integer
@overload fun(fd: integer, unix.F_GETFL: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_SETFL: integer, flags: integer): true
@overload fun(fd: integer, unix.F_SETFL: integer, flags: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_SETLK: integer, type?: integer, start?: integer, len?: integer, whence?: integer): true
@overload fun(fd: integer, unix.F_SETLK: integer, type?: integer, start?: integer, len?: integer, whence?: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_SETLKW: integer, type?: integer, start?: integer, len?: integer, whence?: integer): true
@overload fun(fd: integer, unix.F_SETLKW: integer, type?: integer, start?: integer, len?: integer, whence?: integer): nil, error: unix.Errno
@overload fun(fd: integer, unix.F_GETLK: integer, type?: integer, start?: integer, len?: integer, whence?: integer): unix.F_UNLCK: integer
@overload fun(fd: integer, unix.F_GETLK: integer, type?: integer, start?: integer, len?: integer, whence?: integer): type: integer, start: integer, len: integer, whence: integer, pid: integer
@overload fun(fd: integer, unix.F_GETLK: integer, type?: integer, start?: integer, len?: integer, whence?: integer): nil, error: unix.Errno"
     (_G.unix.fcntl ...))
   :getsid (fn [pid]
     "Gets session id.
@param pid integer
@return integer sid
@nodiscard
@overload fun(pid: integer): nil, error: unix.Errno"
     (_G.unix.getsid pid))
   :getpgrp (fn []
     "Gets process group id.
@return integer pgid
@nodiscard
@overload fun(): nil, error: unix.Errno"
     (_G.unix.getpgrp ))
   :setpgrp (fn []
     "Sets process group id. This is the same as `setpgid(0,0)`.
@return integer pgid
@overload fun(): nil, error: unix.Errno"
     (_G.unix.setpgrp ))
   :setpgid (fn [pid pgid]
     "Sets process group id the modern way.
@param pid integer
@param pgid integer
@return true
@overload fun(pid: integer, pgid: integer): nil, error: unix.Errno"
     (_G.unix.setpgid pid pgid))
   :getpgid (fn [pid]
     "Gets process group id the modern way.
@param pid integer
@overload fun(pid: integer): nil, error: unix.Errno"
     (_G.unix.getpgid pid))
   :setsid (fn []
     "Sets session id.

This function can be used to create daemons.

Fails with `ENOSYS` on Windows NT.
@return integer sid
@overload fun(): nil, error: unix.Errno"
     (_G.unix.setsid ))
   :getuid (fn []
     "Gets real user id.

On Windows this system call is polyfilled by running `GetUserNameW()`
through Knuth's multiplicative hash.

This function does not fail.
@return integer uid
@nodiscard"
     (_G.unix.getuid ))
   :getgid (fn []
     "Sets real group id.

On Windows this system call is polyfilled as getuid().

This function does not fail.
@return integer gid
@nodiscard"
     (_G.unix.getgid ))
   :geteuid (fn []
     "Gets effective user id.

For example, if your redbean is a setuid binary, then getuid() will
return the uid of the user running the program, and geteuid() shall
return zero which means root, assuming that's the file owning user.

On Windows this system call is polyfilled as getuid().

This function does not fail.
@return integer uid
@nodiscard"
     (_G.unix.geteuid ))
   :getegid (fn []
     "Gets effective group id.

On Windows this system call is polyfilled as getuid().

This function does not fail.
@return integer gid
@nodiscard"
     (_G.unix.getegid ))
   :chroot (fn [path]
     "Changes root directory.

Returns `ENOSYS` on Windows NT.
@param path string
@return true
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.chroot path))
   :setuid (fn [uid]
     "Sets user id.

One use case for this function is dropping root privileges. Should
you ever choose to run redbean as root and decide not to use the
`-G` and `-U` flags, you can replicate that behavior in the Lua
processes you spawn as follows:

   ok, err = unix.setgid(1000)  -- check your /etc/groups
   if not ok then Log(kLogFatal, tostring(err)) end
   ok, err = unix.setuid(1000)  -- check your /etc/passwd
   if not ok then Log(kLogFatal, tostring(err)) end

If your goal is to relinquish privileges because redbean is a setuid
binary, then things are more straightforward:

   ok, err = unix.setgid(unix.getgid())
   if not ok then Log(kLogFatal, tostring(err)) end
   ok, err = unix.setuid(unix.getuid())
   if not ok then Log(kLogFatal, tostring(err)) end

See also the setresuid() function and be sure to refer to your local
system manual about the subtleties of changing user id in a way that
isn't restorable.

Returns `ENOSYS` on Windows NT if `uid` isn't `getuid()`.
@param uid integer
@return true
@overload fun(uid: integer): nil, error: unix.Errno"
     (_G.unix.setuid uid))
   :setfsuid (fn [uid]
     "Sets user id for file system ops.
@param uid integer
@return true
@overload fun(uid: integer): nil, error: unix.Errno"
     (_G.unix.setfsuid uid))
   :setgid (fn [gid]
     "Sets group id.

Returns `ENOSYS` on Windows NT if `gid` isn't `getgid()`.
@param gid integer
@return true
@overload fun(gid: integer): nil, error: unix.Errno"
     (_G.unix.setgid gid))
   :setresuid (fn [real effective saved]
     "Sets real, effective, and saved user ids.

If any of the above parameters are -1, then it's a no-op.

Returns `ENOSYS` on Windows NT.
Returns `ENOSYS` on Macintosh and NetBSD if `saved` isn't -1.
@param real integer
@param effective integer
@param saved integer
@return true
@overload fun(real: integer, effective: integer, saved: integer): nil, error: unix.Errno"
     (_G.unix.setresuid real effective saved))
   :setresgid (fn [real effective saved]
     "Sets real, effective, and saved group ids.

If any of the above parameters are -1, then it's a no-op.

Returns `ENOSYS` on Windows NT.
Returns `ENOSYS` on Macintosh and NetBSD if `saved` isn't -1.
@param real integer
@param effective integer
@param saved integer
@return true
@overload fun(real: integer, effective: integer, saved: integer): nil, error: unix.Errno"
     (_G.unix.setresgid real effective saved))
   :umask (fn [newmask]
     "Sets file permission mask and returns the old one.

This is used to remove bits from the `mode` parameter of functions
like open() and mkdir(). The masks typically used are 027 and 022.
Those masks ensure that, even if a file is created with 0666 bits,
it'll be turned into 0640 or 0644 so that users other than the owner
can't modify it.

To read the mask without changing it, try doing this:

    mask = unix.umask(027)
    unix.umask(mask)

On Windows NT this is a no-op and `mask` is returned.

This function does not fail.
@param newmask integer
@return integer oldmask"
     (_G.unix.umask newmask))
   :syslog (fn [priority msg]
     "Generates a log message, which will be distributed by syslogd.

`priority` is a bitmask containing the facility value and the level
value. If no facility value is ORed into priority, then the default
value set by openlog() is used. If set to NULL, the program name is
used. Level is one of `LOG_EMERG`, `LOG_ALERT`, `LOG_CRIT`,
`LOG_ERR`, `LOG_WARNING`, `LOG_NOTICE`, `LOG_INFO`, `LOG_DEBUG`.

This function currently works on Linux, Windows, and NetBSD. On
WIN32 it uses the ReportEvent() facility.
@param priority integer
@param msg string"
     (_G.unix.syslog priority msg))
   :clock_gettime (fn [clock]
     "Returns nanosecond precision timestamp from system, e.g.

   >: unix.clock_gettime()
   1651137352      774458779
   >: Benchmark(unix.clock_gettime)
   126     393     571     1

`clock` can be any one of of:

- `CLOCK_REALTIME` returns a wall clock timestamp represented in
  nanoseconds since the UNIX epoch (~1970). It'll count time in the
  suspend state. This clock is subject to being smeared by various
  adjustments made by NTP. These timestamps can have unpredictable
  discontinuous jumps when clock_settime() is used. Therefore this
  clock is the default clock for everything, even pthread condition
  variables. Cosmopoiltan guarantees this clock will never raise
  `EINVAL` and also guarantees `CLOCK_REALTIME == 0` will always be
  the case. On Windows this maps to GetSystemTimePreciseAsFileTime().
  On platforms with vDSOs like Linux, Windows, and MacOS ARM64 this
  should take about 20 nanoseconds.

- `CLOCK_MONOTONIC` returns a timestamp with an unspecified epoch,
  that should be when the system was powered on. These timestamps
  shouldn't go backwards. Timestamps shouldn't count time spent in
  the sleep, suspend, and hibernation states. These timestamps won't
  be impacted by clock_settime(). These timestamps may be impacted by
  frequency adjustments made by NTP. Cosmopoiltan guarantees this
  clock will never raise `EINVAL`. MacOS and BSDs use the word
  \"uptime\" to describe this clock. On Windows this maps to
  QueryUnbiasedInterruptTimePrecise().

- `CLOCK_BOOTTIME` is a monotonic clock returning a timestamp with an
  unspecified epoch, that should be relative to when the host system
  was powered on. These timestamps shouldn't go backwards. Timestamps
  should also include time spent in a sleep, suspend, or hibernation
  state. These timestamps aren't impacted by clock_settime(), but
  they may be impacted by frequency adjustments made by NTP. This
  clock will raise an `EINVAL` error on extremely old Linux distros
  like RHEL5. MacOS and BSDs use the word \"monotonic\" to describe
  this clock. On Windows this maps to QueryInterruptTimePrecise().

- `CLOCK_MONOTONIC_RAW` returns a timestamp from an unspecified
  epoch. These timestamps don't count time spent in the sleep,
  suspend, and hibernation states. Unlike `CLOCK_MONOTONIC` this
  clock is guaranteed to not be impacted by frequency adjustments or
  discontinuous jumps caused by clock_settime(). Providing this level
  of assurances may make this clock slower than the normal monotonic
  clock. Furthermore this clock may cause `EINVAL` to be raised if
  running on a host system that doesn't provide those guarantees,
  e.g. OpenBSD and MacOS on AMD64.

- `CLOCK_REALTIME_COARSE` is the same as `CLOCK_REALTIME` except
  it'll go faster if the host OS provides a cheaper way to read the
  wall time. Please be warned that coarse can be really coarse.
  Rather than nano precision, you're looking at `CLK_TCK` precision,
  which can lag as far as 30 milliseconds behind or possibly more.
  Cosmopolitan may fallback to `CLOCK_REALTIME` if a faster less
  accurate clock isn't provided by the system. This clock will raise
  an `EINVAL` error on extremely old Linux distros like RHEL5.

- `CLOCK_MONOTONIC_COARSE` is the same as `CLOCK_MONOTONIC` except
  it'll go faster if the host OS provides a cheaper way to read the
  unbiased time. Please be warned that coarse can be really coarse.
  Rather than nano precision, you're looking at `CLK_TCK` precision,
  which can lag as far as 30 milliseconds behind or possibly more.
  Cosmopolitan may fallback to `CLOCK_REALTIME` if a faster less
  accurate clock isn't provided by the system. This clock will raise
  an `EINVAL` error on extremely old Linux distros like RHEL5.

- `CLOCK_PROCESS_CPUTIME_ID` returns the amount of time this process
  was actively scheduled. This is similar to getrusage() and clock().
  Cosmopoiltan guarantees this clock will never raise `EINVAL`.

- `CLOCK_THREAD_CPUTIME_ID` returns the amount of time this thread
  was actively scheduled. This is similar to getrusage() and clock().
  Cosmopoiltan guarantees this clock will never raise `EINVAL`.

Returns `EINVAL` if clock isn't supported on platform.

This function only fails if `clock` is invalid.

This function goes fastest on Linux and Windows.
@param clock? integer
@return integer seconds, integer nanos
@nodiscard
@overload fun(clock?: integer): nil, error: unix.Errno"
     (_G.unix.clock_gettime clock))
   :nanosleep (fn [seconds nanos]
     "Sleeps with nanosecond precision.

Returns `EINTR` if a signal was received while waiting.
@param seconds integer
@param nanos integer?
@return integer remseconds, integer remnanos
@overload fun(seconds: integer, nanos?: integer): nil, error: unix.Errno"
     (_G.unix.nanosleep seconds nanos))
   :sync (fn []
     "These functions are used to make programs slower by asking the
operating system to flush data to the physical medium."
     (_G.unix.sync ))
   :fsync (fn [fd]
     "These functions are used to make programs slower by asking the
operating system to flush data to the physical medium.
@param fd integer
@return true
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.fsync fd))
   :fdatasync (fn [fd]
     "These functions are used to make programs slower by asking the
operating system to flush data to the physical medium.
@param fd integer
@return true
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.fdatasync fd))
   :lseek (fn [fd offset whence]
     "Seeks to file position.

`whence` can be one of:

- `SEEK_SET`: Sets the file position to `offset` [default]
- `SEEK_CUR`: Sets the file position to `position + offset`
- `SEEK_END`: Sets the file position to `filesize + offset`

Returns the new position relative to the start of the file.
@param fd integer
@param offset integer
@param whence? integer
@return integer newposbytes
@overload fun(fd: integer, offset: integer, whence?: integer): nil, error: unix.Errno"
     (_G.unix.lseek fd offset whence))
   :truncate (fn [path len]
     "Reduces or extends underlying physical medium of file.
If file was originally larger, content >length is lost.
@param path string
@param length? integer defaults to zero (`0`)
@return true
@overload fun(path: string, length?: integer): nil, error: unix.Errno"
     (_G.unix.truncate path len))
   :ftruncate (fn [fd len]
     "Reduces or extends underlying physical medium of open file.
If file was originally larger, content >length is lost.
@param fd integer
@param length? integer defaults to zero (`0`)
@return true
@overload fun(fd: integer, length?: integer): nil, error: unix.Errno"
     (_G.unix.ftruncate fd len))
   :socket (fn [family type protocol]
     "@param family? integer defaults to `AF_INET` and can be:

- `AF_INET`: Creates Internet Protocol Version 4 (IPv4) socket.

- `AF_UNIX`: Creates local UNIX domain socket. On the New Technology
this requires Windows 10 and only works with `SOCK_STREAM`.

@param type? integer defaults to `SOCK_STREAM` and can be:

- `SOCK_STREAM`
- `SOCK_DGRAM`
- `SOCK_RAW`
- `SOCK_RDM`
- `SOCK_SEQPACKET`

You may bitwise OR any of the following into `type`:

- `SOCK_CLOEXEC`
- `SOCK_NONBLOCK`

@param protocol? integer may be any of:

- `0` to let kernel choose [default]
- `IPPROTO_TCP`
- `IPPROTO_UDP`
- `IPPROTO_RAW`
- `IPPROTO_IP`
- `IPPROTO_ICMP`

@return integer fd
@nodiscard
@overload fun(family?: integer, type?: integer, protocol?: integer): nil, error: unix.Errno"
     (_G.unix.socket family type protocol))
   :socketpair (fn [family type protocol]
     "Creates bidirectional pipe.

@param family? integer defaults to `AF_UNIX`.
@param type? integer defaults to `SOCK_STREAM` and can be:

- `SOCK_STREAM`
- `SOCK_DGRAM`
- `SOCK_SEQPACKET`

You may bitwise OR any of the following into `type`:

- `SOCK_CLOEXEC`
- `SOCK_NONBLOCK`

@param protocol? integer defaults to `0`.
@return integer fd1, integer fd2
@overload fun(family?: integer, type?: integer, protocol?: integer): nil, error: unix.Errno"
     (_G.unix.socketpair family type protocol))
   :bind (fn [fd ip port]
     " Binds socket.

 `ip` and `port` are in host endian order. For example, if you
 wanted to listen on `1.2.3.4:31337` you could do any of these

     unix.bind(sock, 0x01020304, 31337)
     unix.bind(sock, ParseIp('1.2.3.4'), 31337)
     unix.bind(sock, 1 << 24 | 0 << 16 | 0 << 8 | 1, 31337)

 `ip` and `port` both default to zero. The meaning of bind(0, 0)
 is to listen on all interfaces with a kernel-assigned ephemeral
 port number, that can be retrieved and used as follows:

     sock = assert(unix.socket())  -- create ipv4 tcp socket
     assert(unix.bind(sock))       -- all interfaces ephemeral port
     ip, port = assert(unix.getsockname(sock))
     print(\"listening on ip\", FormatIp(ip), \"port\", port)
     assert(unix.listen(sock))
     while true do
        client, clientip, clientport = assert(unix.accept(sock))
        print(\"got client ip\", FormatIp(clientip), \"port\", clientport)
        unix.close(client)
     end

 Further note that calling `unix.bind(sock)` is equivalent to not
 calling bind() at all, since the above behavior is the default.
@param fd integer
@param ip? uint32
@param port? uint16
@return true
@overload fun(fd: integer, unixpath: string): true
@overload fun(fd: integer, ip?: integer, port?: integer): nil, error: unix.Errno
@overload fun(fd: integer, unixpath: string): nil, error: unix.Errno"
     (_G.unix.bind fd ip port))
   :siocgifconf (fn []
     "Returns list of network adapter addresses.
@return { name: string, ip: integer, netmask: integer }[] addresses
@nodiscard
@overload fun(): nil, error: unix.Errno"
     (_G.unix.siocgifconf ))
   :getsockopt (fn [fd level optname]
     "Tunes networking parameters.

`level` and `optname` may be one of the following pairs. The ellipses
type signature above changes depending on which options are used.

`optname` is the option feature magic number. The constants for
these will be set to `0` if the option isn't supported on the host
platform.

Raises `ENOPROTOOPT` if your `level` / `optname` combination isn't
valid, recognized, or supported on the host platform.

Raises `ENOTSOCK` if `fd` is valid but isn't a socket.

Raises `EBADF` if `fd` isn't valid.

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ value:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, value:bool)
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_TYPE`
- `SOL_SOCKET`, `SO_DEBUG`
- `SOL_SOCKET`, `SO_ACCEPTCONN`
- `SOL_SOCKET`, `SO_BROADCAST`
- `SOL_SOCKET`, `SO_REUSEADDR`
- `SOL_SOCKET`, `SO_REUSEPORT`
- `SOL_SOCKET`, `SO_KEEPALIVE`
- `SOL_SOCKET`, `SO_DONTROUTE`
- `SOL_TCP`, `TCP_NODELAY`
- `SOL_TCP`, `TCP_CORK`
- `SOL_TCP`, `TCP_QUICKACK`
- `SOL_TCP`, `TCP_FASTOPEN_CONNECT`
- `SOL_TCP`, `TCP_DEFER_ACCEPT`
- `SOL_IP`, `IP_HDRINCL`

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ value:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, value:int)
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_SNDBUF`
- `SOL_SOCKET`, `SO_RCVBUF`
- `SOL_SOCKET`, `SO_RCVLOWAT`
- `SOL_SOCKET`, `SO_SNDLOWAT`
- `SOL_TCP`, `TCP_KEEPIDLE`
- `SOL_TCP`, `TCP_KEEPINTVL`
- `SOL_TCP`, `TCP_FASTOPEN`
- `SOL_TCP`, `TCP_KEEPCNT`
- `SOL_TCP`, `TCP_MAXSEG`
- `SOL_TCP`, `TCP_SYNCNT`
- `SOL_TCP`, `TCP_NOTSENT_LOWAT`
- `SOL_TCP`, `TCP_WINDOW_CLAMP`
- `SOL_IP`, `IP_TOS`
- `SOL_IP`, `IP_MTU`
- `SOL_IP`, `IP_TTL`

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ secs:int, nsecs:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, secs:int[, nanos:int])
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_RCVTIMEO`: If this option is specified then
  your stream socket will have a read() / recv() timeout. If the
  specified interval elapses without receiving data, then EAGAIN
  shall be returned by read. If this option is used on listening
  sockets, it'll be inherited by accepted sockets. Your redbean
  already does this for GetClientFd() based on the `-t` flag.

- `SOL_SOCKET`, `SO_SNDTIMEO`: This is the same as `SO_RCVTIMEO`
  but it applies to the write() / send() functions.

unix.getsockopt(fd:int, unix.SOL_SOCKET, unix.SO_LINGER)
    ├─→ seconds:int, enabled:bool
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, unix.SOL_SOCKET, unix.SO_LINGER, secs:int, enabled:bool)
    ├─→ true
    └─→ nil, unix.Errno

This `SO_LINGER` parameter can be used to make close() a blocking
call. Normally when the kernel returns immediately when it receives
close(). Sometimes it's desirable to have extra assurance on errors
happened, even if it comes at the cost of performance.

unix.setsockopt(serverfd:int, unix.SOL_TCP, unix.TCP_SAVE_SYN, enabled:int)
    ├─→ true
    └─→ nil, unix.Errno
unix.getsockopt(clientfd:int, unix.SOL_TCP, unix.TCP_SAVED_SYN)
    ├─→ syn_packet_bytes:str
    └─→ nil, unix.Errno

This `TCP_SAVED_SYN` option may be used to retrieve the bytes of the
TCP SYN packet that the client sent when the connection for `fd` was
opened. In order for this to work, `TCP_SAVE_SYN` must have been set
earlier on the listening socket. This is Linux-only. You can use the
`OnServerListen` hook to enable SYN saving in your Redbean. When the
`TCP_SAVE_SYN` option isn't used, this may return empty string.
@param fd integer
@param level integer
@param optname integer
@return integer value
@nodiscard
@overload fun(fd: integer, level: integer, optname: integer): nil, error: unix.Errno
@overload fun(fd:integer, unix.SOL_SOCKET: integer, unix.SO_LINGER: integer): seconds: integer, enabled: boolean
@overload fun(fd:integer, unix.SOL_SOCKET: integer, unix.SO_LINGER: integer): nil, error: unix.Errno
@overload fun(serverfd:integer, unix.SOL_TCP: integer, unix.TCP_SAVE_SYN: integer): syn_packet_bytes: string
@overload fun(serverfd:integer, unix.SOL_TCP: integer, unix.TCP_SAVE_SYN: integer): nil, error: unix.Errno"
     (_G.unix.getsockopt fd level optname))
   :setsockopt (fn [fd level optname value]
     "Tunes networking parameters.

`level` and `optname` may be one of the following pairs. The ellipses
type signature above changes depending on which options are used.

`optname` is the option feature magic number. The constants for
these will be set to `0` if the option isn't supported on the host
platform.

Raises `ENOPROTOOPT` if your `level` / `optname` combination isn't
valid, recognized, or supported on the host platform.

Raises `ENOTSOCK` if `fd` is valid but isn't a socket.

Raises `EBADF` if `fd` isn't valid.

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ value:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, value:bool)
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_TYPE`
- `SOL_SOCKET`, `SO_DEBUG`
- `SOL_SOCKET`, `SO_ACCEPTCONN`
- `SOL_SOCKET`, `SO_BROADCAST`
- `SOL_SOCKET`, `SO_REUSEADDR`
- `SOL_SOCKET`, `SO_REUSEPORT`
- `SOL_SOCKET`, `SO_KEEPALIVE`
- `SOL_SOCKET`, `SO_DONTROUTE`
- `SOL_TCP`, `TCP_NODELAY`
- `SOL_TCP`, `TCP_CORK`
- `SOL_TCP`, `TCP_QUICKACK`
- `SOL_TCP`, `TCP_FASTOPEN_CONNECT`
- `SOL_TCP`, `TCP_DEFER_ACCEPT`
- `SOL_IP`, `IP_HDRINCL`

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ value:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, value:int)
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_SNDBUF`
- `SOL_SOCKET`, `SO_RCVBUF`
- `SOL_SOCKET`, `SO_RCVLOWAT`
- `SOL_SOCKET`, `SO_SNDLOWAT`
- `SOL_TCP`, `TCP_KEEPIDLE`
- `SOL_TCP`, `TCP_KEEPINTVL`
- `SOL_TCP`, `TCP_FASTOPEN`
- `SOL_TCP`, `TCP_KEEPCNT`
- `SOL_TCP`, `TCP_MAXSEG`
- `SOL_TCP`, `TCP_SYNCNT`
- `SOL_TCP`, `TCP_NOTSENT_LOWAT`
- `SOL_TCP`, `TCP_WINDOW_CLAMP`
- `SOL_IP`, `IP_TOS`
- `SOL_IP`, `IP_MTU`
- `SOL_IP`, `IP_TTL`

unix.getsockopt(fd:int, level:int, optname:int)
    ├─→ secs:int, nsecs:int
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, level:int, optname:int, secs:int[, nanos:int])
    ├─→ true
    └─→ nil, unix.Errno

- `SOL_SOCKET`, `SO_RCVTIMEO`: If this option is specified then
  your stream socket will have a read() / recv() timeout. If the
  specified interval elapses without receiving data, then EAGAIN
  shall be returned by read. If this option is used on listening
  sockets, it'll be inherited by accepted sockets. Your redbean
  already does this for GetClientFd() based on the `-t` flag.

- `SOL_SOCKET`, `SO_SNDTIMEO`: This is the same as `SO_RCVTIMEO`
  but it applies to the write() / send() functions.

unix.getsockopt(fd:int, unix.SOL_SOCKET, unix.SO_LINGER)
    ├─→ seconds:int, enabled:bool
    └─→ nil, unix.Errno
unix.setsockopt(fd:int, unix.SOL_SOCKET, unix.SO_LINGER, secs:int, enabled:bool)
    ├─→ true
    └─→ nil, unix.Errno

This `SO_LINGER` parameter can be used to make close() a blocking
call. Normally when the kernel returns immediately when it receives
close(). Sometimes it's desirable to have extra assurance on errors
happened, even if it comes at the cost of performance.

unix.setsockopt(serverfd:int, unix.SOL_TCP, unix.TCP_SAVE_SYN, enabled:int)
    ├─→ true
    └─→ nil, unix.Errno
unix.getsockopt(clientfd:int, unix.SOL_TCP, unix.TCP_SAVED_SYN)
    ├─→ syn_packet_bytes:str
    └─→ nil, unix.Errno

This `TCP_SAVED_SYN` option may be used to retrieve the bytes of the
TCP SYN packet that the client sent when the connection for `fd` was
opened. In order for this to work, `TCP_SAVE_SYN` must have been set
earlier on the listening socket. This is Linux-only. You can use the
`OnServerListen` hook to enable SYN saving in your Redbean. When the
`TCP_SAVE_SYN` option isn't used, this may return empty string.
@param fd integer
@param level integer
@param optname integer
@param value boolean|integer
@return true
@overload fun(fd: integer, level: integer, optname: integer, value: boolean|integer): nil, error: unix.Errno
@overload fun(fd:integer, unix.SOL_SOCKET: integer, unix.SO_LINGER: integer, secs:integer, enabled:boolean): true
@overload fun(fd:integer, unix.SOL_SOCKET: integer, unix.SO_LINGER: integer, secs:integer, enabled:boolean): nil, error: unix.Errno
@overload fun(serverfd:integer, unix.SOL_TCP: integer, unix.TCP_SAVE_SYN: integer, enabled:integer): true
@overload fun(serverfd:integer, unix.SOL_TCP: integer, unix.TCP_SAVE_SYN: integer, enabled:integer): nil, error: unix.Errno"
     (_G.unix.setsockopt fd level optname value))
   :poll (fn [fds timeoutms]
     "Checks for events on a set of file descriptors.

The table of file descriptors to poll uses sparse integer keys. Any
pairs with non-integer keys will be ignored. Pairs with negative
keys are ignored by poll(). The returned table will be a subset of
the supplied file descriptors.

`events` and `revents` may be any combination (using bitwise OR) of:

- `POLLIN` (events, revents): There is data to read.
- `POLLOUT` (events, revents): Writing is now possible, although may
still block if available space in a socket or pipe is exceeded
(unless `O_NONBLOCK` is set).
- `POLLPRI` (events, revents): There is some exceptional condition
(for example, out-of-band data on a TCP socket).
- `POLLRDHUP` (events, revents): Stream socket peer closed
connection, or shut down writing half of connection.
- `POLLERR` (revents): Some error condition.
- `POLLHUP` (revents): Hang up. When reading from a channel such as
a pipe or a stream socket, this event merely indicates that the
peer closed its end of the channel.
- `POLLNVAL` (revents): Invalid request.

@param fds table<integer,integer> `{[fd:int]=events:int, ...}`
@param timeoutms integer? the number of milliseconds to block.
If this is set to -1 then that means block as long as it takes until there's an
event or an interrupt. If the timeout expires, an empty table is returned.
@return table<integer,integer> `{[fd:int]=revents:int, ...}`
@nodiscard
@overload fun(fds: table<integer,integer>, timeoutms:integer): nil, unix.Errno"
     (_G.unix.poll fds timeoutms))
   :gethostname (fn []
     "Returns hostname of system.
@return string host
@nodiscard
@overload fun(): nil, unix.Errno"
     (_G.unix.gethostname ))
   :listen (fn [fd backlog]
     "Begins listening for incoming connections on a socket.
@param fd integer
@param backlog integer?
@return true
@overload fun(fd:integer, backlog:integer?): nil, unix.Errno"
     (_G.unix.listen fd backlog))
   :accept (fn [serverfd flags]
     "Accepts new client socket descriptor for a listening tcp socket.

`flags` may have any combination (using bitwise OR) of:

- `SOCK_CLOEXEC`
- `SOCK_NONBLOCK`

@param serverfd integer
@param flags integer?
@return integer clientfd, uint32 ip, uint16 port
@nodiscard
@overload fun(serverfd:integer, flags:integer?):clientfd:integer, unixpath:string
@overload fun(serverfd:integer, flags:integer?):nil, unix.Errno"
     (_G.unix.accept serverfd flags))
   :connect (fn [fd ip port]
     " Connects a TCP socket to a remote host.

 With TCP this is a blocking operation. For a UDP socket it simply
 remembers the intended address so that `send()` or `write()` may be used
 rather than `sendto()`.
@param fd integer
@param ip uint32
@param port uint16
@return true
@overload fun(fd:integer, ip:integer, port:integer): nil, unix.Errno
@overload fun(fd:integer, unixpath:string): true
@overload fun(fd:integer, unixpath:string): nil, unix.Errno"
     (_G.unix.connect fd ip port))
   :getsockname (fn [fd]
     "Retrieves the local address of a socket.
@param fd integer
@return uint32 ip, uint16 port
@nodiscard
@overload fun(fd: integer): unixpath:string
@overload fun(fd: integer): nil, unix.Errno"
     (_G.unix.getsockname fd))
   :getpeername (fn [fd]
     "Retrieves the remote address of a socket.

This operation will either fail on `AF_UNIX` sockets or return an
empty string.

@param fd integer
@return uint32 ip, uint16 port
@nodiscard
@overload fun(fd: integer): unixpath:string
@overload fun(fd: integer): nil, unix.Errno"
     (_G.unix.getpeername fd))
   :recv (fn [fd bufsiz flags]
     "@param fd integer
@param bufsiz integer?
@param flags integer? may have any combination (using bitwise OR) of:
- `MSG_WAITALL`
- `MSG_DONTROUTE`
- `MSG_PEEK`
- `MSG_OOB`
@return string data
@nodiscard
@overload fun(fd: integer, bufsiz?: integer, flags?: integer): nil, unix.Errno"
     (_G.unix.recv fd bufsiz flags))
   :recvfrom (fn [fd bufsiz flags]
     "@param fd integer
@param bufsiz integer?
@param flags integer? may have any combination (using bitwise OR) of:
- `MSG_WAITALL`
- `MSG_DONTROUTE`
- `MSG_PEEK`
- `MSG_OOB`
@return string data, integer ip, integer port
@nodiscard
@overload fun(fd: integer, bufsiz?: integer, flags?: integer): data: string, unixpath: string
@overload fun(fd: integer, bufsiz?: integer, flags?: integer): nil, unix.Errno"
     (_G.unix.recvfrom fd bufsiz flags))
   :send (fn [fd data flags]
     "This is the same as `write` except it has a `flags` argument
that's intended for sockets.
@param fd integer
@param data string
@param flags integer? may have any combination (using bitwise OR) of:
- `MSG_NOSIGNAL`: Don't SIGPIPE on EOF
- `MSG_OOB`: Send stream data through out of bound channel
- `MSG_DONTROUTE`: Don't go through gateway (for diagnostics)
- `MSG_MORE`: Manual corking to belay nodelay (0 on non-Linux)
@return integer sent
@overload fun(fd: integer, data: string, flags?: integer): nil, unix.Errno"
     (_G.unix.send fd data flags))
   :sendto (fn [fd data ip port flags]
     "This is useful for sending messages over UDP sockets to specific
addresses.

@param fd integer
@param data string
@param ip uint32
@param port uint16
@param flags? integer may have any combination (using bitwise OR) of:
- `MSG_OOB`
- `MSG_DONTROUTE`
- `MSG_NOSIGNAL`
@return integer sent
@overload fun(fd:integer, data:string, ip:integer, port:integer, flags?:integer): nil, unix.Errno
@overload fun(fd:integer, data:string, unixpath:string, flags?:integer): sent: integer
@overload fun(fd:integer, data:string, unixpath:string, flags?:integer): nil, unix.Errno"
     (_G.unix.sendto fd data ip port flags))
   :shutdown (fn [fd how]
     "Partially closes socket.

@param fd integer
@param how integer is set to one of:

- `SHUT_RD`: sends a tcp half close for reading
- `SHUT_WR`: sends a tcp half close for writing
- `SHUT_RDWR`

This system call currently has issues on Macintosh, so portable code
should log rather than assert failures reported by `shutdown()`.

@return true
@overload fun(fd: integer, how: integer): nil, error: unix.Errno"
     (_G.unix.shutdown fd how))
   :sigprocmask (fn [how newmask]
     "Manipulates bitset of signals blocked by process.

@param how integer can be one of:

- `SIG_BLOCK`: applies `mask` to set of blocked signals using bitwise OR
- `SIG_UNBLOCK`: removes bits in `mask` from set of blocked signals
- `SIG_SETMASK`: replaces process signal mask with `mask`

`mask` is a unix.Sigset() object (see section below).

For example, to temporarily block `SIGTERM` and `SIGINT` so critical
work won't be interrupted, sigprocmask() can be used as follows:

  newmask = unix.Sigset(unix.SIGTERM)
  oldmask = assert(unix.sigprocmask(unix.SIG_BLOCK, newmask))
  -- do something...
  assert(unix.sigprocmask(unix.SIG_SETMASK, oldmask))

@param newmask unix.Sigset
@return unix.Sigset oldmask
@overload fun(how: integer, newmask: unix.Sigset): nil, error: unix.Errno"
     (_G.unix.sigprocmask how newmask))
   :sigaction (fn [sig handler flags mask]
     "@param sig integer can be one of:

- `unix.SIGINT`
- `unix.SIGQUIT`
- `unix.SIGTERM`
- etc.

@param handler? function|integer can be:

- Lua function
- `unix.SIG_IGN`
- `unix.SIG_DFL`

@param flags? integer can have:

- `unix.SA_RESTART`: Enables BSD signal handling semantics. Normally
i/o entrypoints check for pending signals to deliver. If one gets
delivered during an i/o call, the normal behavior is to cancel the
i/o operation and return -1 with `EINTR` in errno. If you use the
`SA_RESTART` flag then that behavior changes, so that any function
that's been annotated with @restartable will not return `EINTR`
and will instead resume the i/o operation. This makes coding
easier but it can be an anti-pattern if not used carefully, since
poor usage can easily result in latency issues. It also requires
one to do more work in signal handlers, so special care needs to
be given to which C library functions are @asyncsignalsafe.

- `unix.SA_RESETHAND`: Causes signal handler to be single-shot. This
means that, upon entry of delivery to a signal handler, it's reset
to the `SIG_DFL` handler automatically. You may use the alias
`SA_ONESHOT` for this flag, which means the same thing.

- `unix.SA_NODEFER`: Disables the reentrancy safety check on your signal
handler. Normally that's a good thing, since for instance if your
`SIGSEGV` signal handler happens to segfault, you're going to want
your process to just crash rather than looping endlessly. But in
some cases it's desirable to use `SA_NODEFER` instead, such as at
times when you wish to `longjmp()` out of your signal handler and
back into your program. This is only safe to do across platforms
for non-crashing signals such as `SIGCHLD` and `SIGINT`. Crash
handlers should use Xed instead to recover execution, because on
Windows a `SIGSEGV` or `SIGTRAP` crash handler might happen on a
separate stack and/or a separate thread. You may use the alias
`SA_NOMASK` for this flag, which means the same thing.

- `unix.SA_NOCLDWAIT`: Changes `SIGCHLD` so the zombie is gone and
you can't call wait() anymore; similar but may still deliver the
SIGCHLD.

- `unix.SA_NOCLDSTOP`: Lets you set `SIGCHLD` handler that's only
notified on exit/termination and not notified on `SIGSTOP`,
`SIGTSTP`, `SIGTTIN`, `SIGTTOU`, or `SIGCONT`.

Example:

    function OnSigUsr1(sig)
        gotsigusr1 = true
    end
    gotsigusr1 = false
    oldmask = assert(unix.sigprocmask(unix.SIG_BLOCK, unix.Sigset(unix.SIGUSR1)))
    assert(unix.sigaction(unix.SIGUSR1, OnSigUsr1))
    assert(unix.raise(unix.SIGUSR1))
    assert(not gotsigusr1)
    ok, err = unix.sigsuspend(oldmask)
    assert(not ok)
    assert(err:errno() == unix.EINTR)
    assert(gotsigusr1)
    assert(unix.sigprocmask(unix.SIG_SETMASK, oldmask))

It's a good idea to not do too much work in a signal handler.

@param mask? unix.Sigset
@return function|integer oldhandler, integer flags, unix.Sigset mask
@overload fun(sig: integer, handler?: function|integer, flags?: integer, mask?: unix.Sigset): nil, error: unix.Errno"
     (_G.unix.sigaction sig handler flags mask))
   :sigsuspend (fn [mask]
     "Waits for signal to be delivered.

The signal mask is temporarily replaced with `mask` during this system call.
@param mask? unix.Sigset specifies which signals should be blocked.
@return nil, unix.Errno error"
     (_G.unix.sigsuspend mask))
   :setitimer (fn [which intervalsec intervalns valuesec valuens]
     "Causes `SIGALRM` signals to be generated at some point(s) in the
future. The `which` parameter should be `ITIMER_REAL`.

Here's an example of how to create a 400 ms interval timer:

    ticks = 0
    assert(unix.sigaction(unix.SIGALRM, function(sig)
       print('tick no. %d' % {ticks})
       ticks = ticks + 1
    end))
    assert(unix.setitimer(unix.ITIMER_REAL, 0, 400e6, 0, 400e6))
    while true do
       unix.sigsuspend()
    end

Here's how you'd do a single-shot timeout in 1 second:

    unix.sigaction(unix.SIGALRM, MyOnSigAlrm, unix.SA_RESETHAND)
    unix.setitimer(unix.ITIMER_REAL, 0, 0, 1, 0)

@param which integer
@param intervalsec integer
@param intervalns integer needs to be on the interval `[0,1000000000)`
@param valuesec integer
@param valuens integer needs to be on the interval `[0,1000000000)`
@return integer intervalsec, integer intervalns, integer valuesec, integer valuens
@overload fun(which: integer): intervalsec: integer, intervalns: integer, valuesec: integer, valuens: integer
@overload fun(which: integer, intervalsec: integer, intervalns: integer, valuesec: integer, valuens: integer): nil, error: unix.Errno
@overload fun(which: integer): nil, error: unix.Errno"
     (_G.unix.setitimer which intervalsec intervalns valuesec valuens))
   :strsignal (fn [sig]
     "Turns platform-specific `sig` code into its symbolic name.

For example:

    >: unix.strsignal(9)
    \"SIGKILL\"
    >: unix.strsignal(unix.SIGKILL)
    \"SIGKILL\"

Please note that signal numbers are normally different across
supported platforms, and the constants should be preferred.

@param sig integer
@return string signalname
@nodiscard"
     (_G.unix.strsignal sig))
   :setrlimit (fn [resource soft hard]
     "Changes resource limit.

@param resource integer may be one of:

- `RLIMIT_AS` limits the size of the virtual address space. This
will work on all platforms. It's emulated on XNU and Windows which
means it won't propagate across execve() currently.

- `RLIMIT_CPU` causes `SIGXCPU` to be sent to the process when the
soft limit on CPU time is exceeded, and the process is destroyed
when the hard limit is exceeded. It works everywhere but Windows
where it should be possible to poll getrusage() with setitimer().

- `RLIMIT_FSIZE` causes `SIGXFSZ` to sent to the process when the
soft limit on file size is exceeded and the process is destroyed
when the hard limit is exceeded. It works everywhere but Windows.

- `RLIMIT_NPROC` limits the number of simultaneous processes and it
should work on all platforms except Windows. Please be advised it
limits the process, with respect to the activities of the user id
as a whole.

- `RLIMIT_NOFILE` limits the number of open file descriptors and it
should work on all platforms except Windows (TODO).

If a limit isn't supported by the host platform, it'll be set to
127. On most platforms these limits are enforced by the kernel and
as such are inherited by subprocesses.

@param soft integer
@param hard? integer defaults to whatever was specified in `soft`.
@return true
@overload fun(resource: integer, soft: integer, hard?: integer): nil, error: unix.Errno"
     (_G.unix.setrlimit resource soft hard))
   :getrlimit (fn [resource]
     "Returns information about resource limits for current process.
@param resource integer
@return integer soft, integer hard
@nodiscard
@overload fun(resource: integer): nil, error: unix.Errno"
     (_G.unix.getrlimit resource))
   :getrusage (fn [who]
     "Returns information about resource usage for current process, e.g.

    >: unix.getrusage()
    {utime={0, 53644000}, maxrss=44896, minflt=545, oublock=24, nvcsw=9}

@param who? integer defaults to `RUSAGE_SELF` and can be any of:

- `RUSAGE_SELF`: current process
- `RUSAGE_THREAD`: current thread
- `RUSAGE_CHILDREN`: not supported on Windows NT
- `RUSAGE_BOTH`: not supported on non-Linux

@return unix.Rusage # See `unix.Rusage` for details on returned fields.
@nodiscard
@overload fun(who?: integer): nil, error: unix.Errno"
     (_G.unix.getrusage who))
   :pledge (fn [promises execpromises mode]
     "Restrict system operations.

This can be used to sandbox your redbean workers. It allows finer
customization compared to the `-S` flag.

Pledging causes most system calls to become unavailable. On Linux the
disabled calls will return EPERM whereas OpenBSD kills the process.

Using pledge is irreversible. On Linux it causes PR_SET_NO_NEW_PRIVS
to be set on your process.

By default exit and exit_group are always allowed. This is useful
for processes that perform pure computation and interface with the
parent via shared memory.

Once pledge is in effect, the chmod functions (if allowed) will not
permit the sticky/setuid/setgid bits to change. Linux will EPERM here
and OpenBSD should ignore those three bits rather than crashing.

User and group IDs also can't be changed once pledge is in effect.
OpenBSD should ignore the chown functions without crashing. Linux
will just EPERM.

Memory functions won't permit creating executable code after pledge.
Restrictions on origin of SYSCALL instructions will become enforced
on Linux (cf. msyscall) after pledge too, which means the process
gets killed if SYSCALL is used outside the .privileged section. One
exception is if the \"exec\" group is specified, in which case these
restrictions need to be loosened.

@param promises? string may include any of the following groups delimited by spaces.
This list has been curated to focus on the
system calls for which this module provides wrappers. See the
Cosmopolitan Libc pledge() documentation for a comprehensive and
authoritative list of raw system calls. Having the raw system call
list may be useful if you're executing foreign programs.

### stdio

Allows read, write, send, recv, recvfrom, close, clock_getres,
clock_gettime, dup, fchdir, fstat, fsync, fdatasync, ftruncate,
getdents, getegid, getrandom, geteuid, getgid, getgroups,
getitimer, getpgid, getpgrp, getpid, hgetppid, getresgid,
getresuid, getrlimit, getsid, gettimeofday, getuid, lseek,
madvise, brk, mmap/mprotect (PROT_EXEC isn't allowed), msync,
munmap, gethostname, nanosleep, pipe, pipe2, poll, setitimer,
shutdown, sigaction, sigsuspend, sigprocmask, socketpair, umask,
wait4, getrusage, ioctl(FIONREAD), ioctl(FIONBIO), ioctl(FIOCLEX),
ioctl(FIONCLEX), fcntl(F_GETFD), fcntl(F_SETFD), fcntl(F_GETFL),
fcntl(F_SETFL).

### rpath

Allows chdir, getcwd, open, stat, fstat, access, readlink, chmod,
chmod, fchmod.

### wpath

Allows getcwd, open, stat, fstat, access, readlink, chmod, fchmod.

### cpath

Allows rename, link, symlink, unlink, mkdir, rmdir.

### fattr

Allows chmod, fchmod, utimensat, futimens.

### flock

Allows flock, fcntl(F_GETLK), fcntl(F_SETLK), fcntl(F_SETLKW).

### tty

Allows isatty, tiocgwinsz, tcgets, tcsets, tcsetsw, tcsetsf.

### inet

Allows socket (AF_INET), listen, bind, connect, accept,
getpeername, getsockname, setsockopt, getsockopt.

### unix

Allows socket (AF_UNIX), listen, bind, connect, accept,
getpeername, getsockname, setsockopt, getsockopt.

### dns

Allows sendto, recvfrom, socket(AF_INET), connect.

### recvfd

Allows recvmsg, recvmmsg.

### sendfd

Allows sendmsg, sendmmsg.

### proc

Allows fork, vfork, clone, kill, tgkill, getpriority, setpriority,
setrlimit, setpgid, setsid.

### id

Allows setuid, setreuid, setresuid, setgid, setregid, setresgid,
setgroups, setrlimit, getpriority, setpriority.

### settime

Allows settimeofday and clock_adjtime.

### unveil

Allows unveil().

### exec

Allows execve.

If the executable in question needs a loader, then you will need
\"rpath prot_exec\" too. With APE, security is strongest when you
assimilate your binaries beforehand, using the --assimilate flag,
or the o//tool/build/assimilate program. On OpenBSD this is
mandatory.

### prot_exec

Allows mmap(PROT_EXEC) and mprotect(PROT_EXEC).

This may be needed to launch non-static non-native executables,
such as non-assimilated APE binaries, or programs that link
dynamic shared objects, i.e. most Linux distro binaries.

@param execpromises? string only matters if \"exec\" is specified in `promises`.
In that case, this specifies the promises that'll apply once `execve()`
happens. If this is `NULL` then the default is used, which is
unrestricted. OpenBSD allows child processes to escape the sandbox
(so a pledged OpenSSH server process can do things like spawn a root
shell). Linux however requires monotonically decreasing privileges.
This function will will perform some validation on Linux to make
sure that `execpromises` is a subset of `promises`. Your libc
wrapper for `execve()` will then apply its SECCOMP BPF filter later.
Since Linux has to do this before calling `sys_execve()`, the executed
process will be weakened to have execute permissions too.

@param mode integer? if specified should specify one penalty:

- `unix.PLEDGE_PENALTY_KILL_THREAD` causes the violating thread to
  be killed. This is the default on Linux. It's effectively the
  same as killing the process, since redbean has no threads. The
  termination signal can't be caught and will be either `SIGSYS`
  or `SIGABRT`. Consider enabling stderr logging below so you'll
  know why your program failed. Otherwise check the system log.

- `unix.PLEDGE_PENALTY_KILL_PROCESS` causes the process and all
  its threads to be killed. This is always the case on OpenBSD.

- `unix.PLEDGE_PENALTY_RETURN_EPERM` causes system calls to just
  return an `EPERM` error instead of killing. This is a gentler
  solution that allows code to display a friendly warning. Please
  note this may lead to weird behaviors if the software being
  sandboxed is lazy about checking error results.

`mode` may optionally bitwise or the following flags:

- `unix.PLEDGE_STDERR_LOGGING` enables friendly error message
  logging letting you know which promises are needed whenever
  violations occur. Without this, violations will be logged to
  `dmesg` on Linux if the penalty is to kill the process. You
  would then need to manually look up the system call number and
  then cross reference it with the cosmopolitan libc pledge()
  documentation. You can also use `strace -ff` which is easier.
  This is ignored OpenBSD, which already has a good system log.
  Turning on stderr logging (which uses SECCOMP trapping) also
  means that the `unix.WTERMSIG()` on your killed processes will
  always be `unix.SIGABRT` on both Linux and OpenBSD. Otherwise,
  Linux prefers to raise `unix.SIGSYS`.
@return true
@overload fun(promises?: string, execpromises?: string, mode?: integer): nil, error: unix.Errno"
     (_G.unix.pledge promises execpromises mode))
   :unveil (fn [path permissions]
     "Restricts filesystem operations, e.g.

   unix.unveil(\".\", \"r\");     -- current dir + children visible
   unix.unveil(\"/etc\", \"r\");  -- make /etc readable too
   unix.unveil(nil, nil);     -- commit and lock policy

Unveiling restricts a thread's view of the filesystem to a set of
allowed paths with specific privileges.

Once you start using unveil(), the entire file system is considered
hidden. You then specify, by repeatedly calling unveil(), which paths
should become unhidden. When you're finished, you call `unveil(nil,nil)`
which commits your policy, after which further use is forbidden, in
the current thread, as well as any threads or processes it spawns.

There are some differences between unveil() on Linux versus OpenBSD.

1. Build your policy and lock it in one go. On OpenBSD, policies take
 effect immediately and may evolve as you continue to call unveil()
 but only in a more restrictive direction. On Linux, nothing will
 happen until you call `unveil(nil,nil)` which commits and locks.

2. Try not to overlap directory trees. On OpenBSD, if directory trees
 overlap, then the most restrictive policy will be used for a given
 file. On Linux overlapping may result in a less restrictive policy
 and possibly even undefined behavior.

3. OpenBSD and Linux disagree on error codes. On OpenBSD, accessing
 paths outside of the allowed set raises ENOENT, and accessing ones
 with incorrect permissions raises EACCES. On Linux, both these
 cases raise EACCES.

4. Unlike OpenBSD, Linux does nothing to conceal the existence of
 paths. Even with an unveil() policy in place, it's still possible
 to access the metadata of all files using functions like stat()
 and open(O_PATH), provided you know the path. A sandboxed process
 can always, for example, determine how many bytes of data are in
 /etc/passwd, even if the file isn't readable. But it's still not
 possible to use opendir() and go fishing for paths which weren't
 previously known.

This system call is supported natively on OpenBSD and polyfilled on
Linux using the Landlock LSM[1].

@param path string is the file or directory to unveil

@param permissions string is a string consisting of zero or more of the following characters:

- `r` makes `path` available for read-only path operations,
  corresponding to the pledge promise \"rpath\".

- `w` makes `path` available for write operations, corresponding
  to the pledge promise \"wpath\".

- `x` makes `path` available for execute operations,
  corresponding to the pledge promises \"exec\" and \"execnative\".

- `c` allows `path` to be created and removed, corresponding to
  the pledge promise \"cpath\".

@return true
@overload fun(path: string, permissions: string): nil, error: unix.Errno
@overload fun(path: nil, permissions: nil): true"
     (_G.unix.unveil path permissions))
   :gmtime (fn [unixts]
     "Breaks down UNIX timestamp into Zulu Time numbers.
@param unixts integer
@return integer year
@return integer mon 1 ≤ mon ≤ 12
@return integer mday 1 ≤ mday ≤ 31
@return integer hour 0 ≤ hour ≤ 23
@return integer min 0 ≤ min ≤ 59
@return integer sec 0 ≤ sec ≤ 60
@return integer gmtoffsec ±93600 seconds
@return integer wday 0 ≤ wday ≤ 6
@return integer yday 0 ≤ yday ≤ 365
@return integer dst 1 if daylight savings, 0 if not, -1 if unknown
@return string zone
@nodiscard
@overload fun(unixts: integer): nil, error: unix.Errno"
     (_G.unix.gmtime unixts))
   :localtime (fn [unixts]
     "Breaks down UNIX timestamp into local time numbers, e.g.

    >: unix.localtime(unix.clock_gettime())
    2022    4       28      2       14      22      -25200  4       117     1       \"PDT\"

This follows the same API as `gmtime()` which has further details.

Your redbean ships with a subset of the time zone database.

- `/zip/usr/share/zoneinfo/Honolulu`   Z-10
- `/zip/usr/share/zoneinfo/Anchorage`  Z -9
- `/zip/usr/share/zoneinfo/GST`        Z -8
- `/zip/usr/share/zoneinfo/Boulder`    Z -6
- `/zip/usr/share/zoneinfo/Chicago`    Z -5
- `/zip/usr/share/zoneinfo/New_York`   Z -4
- `/zip/usr/share/zoneinfo/UTC`        Z +0
- `/zip/usr/share/zoneinfo/GMT`        Z +0
- `/zip/usr/share/zoneinfo/London`     Z +1
- `/zip/usr/share/zoneinfo/Berlin`     Z +2
- `/zip/usr/share/zoneinfo/Israel`     Z +3
- `/zip/usr/share/zoneinfo/India`      Z +5
- `/zip/usr/share/zoneinfo/Beijing`    Z +8
- `/zip/usr/share/zoneinfo/Japan`      Z +9
- `/zip/usr/share/zoneinfo/Sydney`     Z+10

You can control which timezone is used using the `TZ` environment
variable. If your time zone isn't included in the above list, you
can simply copy it inside your redbean. The same is also the case
for future updates to the database, which can be swapped out when
needed, without having to recompile.

@param unixts integer
@return integer year
@return integer mon 1 ≤ mon ≤ 12
@return integer mday 1 ≤ mday ≤ 31
@return integer hour 0 ≤ hour ≤ 23
@return integer min 0 ≤ min ≤ 59
@return integer sec 0 ≤ sec ≤ 60
@return integer gmtoffsec ±93600 seconds
@return integer wday 0 ≤ wday ≤ 6
@return integer yday 0 ≤ yday ≤ 365
@return integer dst 1 if daylight savings, 0 if not, -1 if unknown
@return string zone
@overload fun(unixts: integer): nil, error: unix.Errno"
     (_G.unix.localtime unixts))
   :stat (fn [path flags dirfd]
     "Gets information about file or directory.
@param flags? integer may have any of:
- `AT_SYMLINK_NOFOLLOW`: do not follow symbolic links.
@param dirfd? integer defaults to `unix.AT_FDCWD` and may optionally be set to a directory file descriptor to which `path` is relative.
@return unix.Stat
@nodiscard
@overload fun(path: string, flags?: integer, dirfd?: integer): nil, unix.Errno"
     (_G.unix.stat path flags dirfd))
   :fstat (fn [fd]
     "Gets information about opened file descriptor.

@param fd integer should be a file descriptor that was opened using `unix.open(path, O_RDONLY|O_DIRECTORY)`.

`flags` may have any of:

- `AT_SYMLINK_NOFOLLOW`: do not follow symbolic links.

`dirfd` defaults to to `unix.AT_FDCWD` and may optionally be set to
a directory file descriptor to which `path` is relative.

A common use for `fstat()` is getting the size of a file. For example:

    fd = assert(unix.open(\"hello.txt\", unix.O_RDONLY))
    st = assert(unix.fstat(fd))
    Log(kLogInfo, 'hello.txt is %d bytes in size' % {st:size()})
    unix.close(fd)

@return unix.Stat
@nodiscard
@overload fun(fd: integer): nil, unix.Errno"
     (_G.unix.fstat fd))
   :opendir (fn [path]
     "Opens directory for listing its contents.

For example, to print a simple directory listing:

    Write('<ul>\\r\\n')
    for name, kind, ino, off in assert(unix.opendir(dir)) do
        if name ~= '.' and name ~= '..' then
           Write('<li>%s\\r\\n' % {EscapeHtml(name)})
        end
    end
    Write('</ul>\\r\\n')

@param path string
@return unix.Dir state
@nodiscard
@overload fun(path: string): nil, error: unix.Errno"
     (_G.unix.opendir path))
   :fdopendir (fn [fd]
     "Opens directory for listing its contents, via an fd.

@param fd integer should be created by `open(path, O_RDONLY|O_DIRECTORY)`.
The returned `unix.Dir` takes ownership of the file descriptor
and will close it automatically when garbage collected.

@return function next, unix.Dir state
@nodiscard
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.fdopendir fd))
   :isatty (fn [fd]
     "Returns true if file descriptor is a teletypewriter. Otherwise nil
with an Errno object holding one of the following values:

- `ENOTTY` if `fd` is valid but not a teletypewriter
- `EBADF` if `fd` isn't a valid file descriptor.
- `EPERM` if pledge() is used without `tty` in lenient mode

No other error numbers are possible.

@param fd integer
@return true
@nodiscard
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.isatty fd))
   :tiocgwinsz (fn [fd]
     "@param fd integer
@return integer rows, integer cols cellular dimensions of pseudoteletypewriter display.
@nodiscard
@overload fun(fd: integer): nil, error: unix.Errno"
     (_G.unix.tiocgwinsz fd))
   :tmpfd (fn []
     "Returns file descriptor of open anonymous file.

This creates a secure temporary file inside `$TMPDIR`. If it isn't
defined, then `/tmp` is used on UNIX and GetTempPath() is used on
the New Technology. This resolution of `$TMPDIR` happens once.

Once close() is called, the returned file is guaranteed to be
deleted automatically. On UNIX the file is unlink()'d before this
function returns. On the New Technology it happens upon close().

On the New Technology, temporary files created by this function
should have better performance, because `kNtFileAttributeTemporary`
asks the kernel to more aggressively cache and reduce i/o ops.
@return integer fd
@overload fun(): nil, error: unix.Errno"
     (_G.unix.tmpfd ))
   :sched_yield (fn []
     "Relinquishes scheduled quantum."
     (_G.unix.sched_yield ))
   :mapshared (fn [size]
     "Creates interprocess shared memory mapping.

This function allocates special memory that'll be inherited across
fork in a shared way. By default all memory in Redbean is \"private\"
memory that's only viewable and editable to the process that owns
it. When unix.fork() happens, memory is copied appropriately so
that changes to memory made in the child process, don't clobber
the memory at those same addresses in the parent process. If you
don't want that to happen, and you want the memory to be shared
similar to how it would be shared if you were using threads, then
you can use this function to achieve just that.

The memory object this function returns may be accessed using its
methods, which support atomics and futexes. It's very low-level.
For example, you can use it to implement scalable mutexes:

    mem = unix.mapshared(8000 * 8)

    LOCK = 0 -- pick an arbitrary word index for lock

    -- From Futexes Are Tricky Version 1.1 § Mutex, Take 3;
    -- Ulrich Drepper, Red Hat Incorporated, June 27, 2004.
    function Lock()
        local ok, old = mem:cmpxchg(LOCK, 0, 1)
        if not ok then
            if old == 1 then
                old = mem:xchg(LOCK, 2)
            end
            while old > 0 do
                mem:wait(LOCK, 2)
                old = mem:xchg(LOCK, 2)
            end
        end
    end
    function Unlock()
        old = mem:add(LOCK, -1)
        if old == 2 then
            mem:store(LOCK, 0)
            mem:wake(LOCK, 1)
        end
    end

It's possible to accomplish the same thing as unix.mapshared()
using files and unix.fcntl() advisory locks. However this goes
significantly faster. For example, that's what SQLite does and
we recommend using SQLite for IPC in redbean. But, if your app
has thousands of forked processes fighting for a file lock you
might need something lower level than file locks, to implement
things like throttling. Shared memory is a good way to do that
since there's nothing that's faster.

@param size integer
The `size` parameter needs to be a multiple of 8. The returned
memory is zero initialized. When allocating shared memory, you
should try to get as much use out of it as possible, since the
overhead of allocating a single shared mapping is 500 words of
resident memory and 8000 words of virtual memory. It's because
the Cosmopolitan Libc mmap() granularity is 2**16.

This system call does not fail. An exception is instead thrown
if sufficient memory isn't available.

@return unix.Memory"
     (_G.unix.mapshared size))
   :sigset (fn [...]
     "@class unix.Sigset: userdata
The unix.Sigset class defines a mutable bitset that may currently
contain 128 entries. See `unix.NSIG` to find out how many signals
your operating system actually supports.

Constructs new signal bitset object.
@param sig integer
@param ... integer
@return unix.Sigset
@nodiscard"
     (_G.unix.Sigset ...))

   :S_ISREG (fn [mode]
     "returns true if mode is a regular file"
     (_G.unix.S_ISREG mode))
   :S_ISDIR (fn [mode]
     "returns true if mode is a directory"
     (_G.unix.S_ISDIR mode))
   :S_ISLNK (fn [mode]
     "returns true if mode is a symbolic link"
     (_G.unix.S_ISLNK mode))
   :S_ISCHR (fn [mode]
     "returns true if mode is a character device"
     (_G.unix.S_ISCHR mode))
   :S_ISBLK (fn [mode]
     "returns true if mode is a block device"
     (_G.unix.S_ISBLK mode))
   :S_ISFIFO (fn [mode]
     "returns true if mode is a named pipe"
     (_G.unix.S_ISFIFO mode))
   :S_ISSOCK (fn [mode]
     "returns true if mode is a named socket"
     (_G.unix.S_ISSOCK mode))


   :AF_INET 2
   :AF_UNIX 1
   :AF_UNSPEC 0
   :ARG_MAX 1048576
   :AT_EACCESS 16
   :AT_FDCWD -2
   :AT_SYMLINK_NOFOLLOW 32
   :BUFSIZ 4096
   :CLK_TCK 100
   :CLOCK_BOOTTIME 127
   :CLOCK_BOOTTIME_ALARM 127
   :CLOCK_MONOTONIC 6
   :CLOCK_MONOTONIC_COARSE 5
   :CLOCK_MONOTONIC_FAST 6
   :CLOCK_MONOTONIC_PRECISE 6
   :CLOCK_MONOTONIC_RAW 4
   :CLOCK_PROCESS_CPUTIME_ID 12
   :CLOCK_PROF 127
   :CLOCK_REALTIME 0
   :CLOCK_REALTIME_ALARM 127
   :CLOCK_REALTIME_COARSE 0
   :CLOCK_REALTIME_FAST 0
   :CLOCK_REALTIME_PRECISE 0
   :CLOCK_SECOND 127
   :CLOCK_TAI 127
   :CLOCK_THREAD_CPUTIME_ID 16
   :CLOCK_UPTIME 8
   :CLOCK_UPTIME_FAST 127
   :CLOCK_UPTIME_PRECISE 127
   :DT_BLK 6
   :DT_CHR 2
   :DT_DIR 4
   :DT_FIFO 1
   :DT_LNK 10
   :DT_REG 8
   :DT_SOCK 12
   :DT_UNKNOWN 0
   :E2BIG 7
   :EACCES 13
   :EADDRINUSE 48
   :EADDRNOTAVAIL 49
   :EAFNOSUPPORT 47
   :EAGAIN 35
   :EALREADY 37
   :EBADF 9
   :EBADFD 9
   :EBADMSG 94
   :EBUSY 16
   :ECANCELED 89
   :ECHILD 10
   :ECONNABORTED 53
   :ECONNREFUSED 61
   :ECONNRESET 54
   :EDEADLK 11
   :EDESTADDRREQ 39
   :EDOM 33
   :EDQUOT 69
   :EEXIST 17
   :EFAULT 14
   :EFBIG 27
   :EHOSTDOWN 64
   :EHOSTUNREACH 65
   :EIDRM 90
   :EILSEQ 92
   :EINPROGRESS 36
   :EINTR 4
   :EINVAL 22
   :EIO 5
   :EISCONN 56
   :EISDIR 21
   :ELOOP 62
   :EMFILE 24
   :EMLINK 31
   :EMSGSIZE 40
   :ENAMETOOLONG 63
   :ENETDOWN 50
   :ENETRESET 52
   :ENETUNREACH 51
   :ENFILE 23
   :ENOBUFS 55
   :ENODATA 96
   :ENODEV 19
   :ENOENT 2
   :ENOEXEC 8
   :ENOLCK 77
   :ENOMEM 12
   :ENOMSG 91
   :ENONET 317
   :ENOPROTOOPT 42
   :ENOSPC 28
   :ENOSYS 78
   :ENOTBLK 15
   :ENOTCONN 57
   :ENOTDIR 20
   :ENOTEMPTY 66
   :ENOTRECOVERABLE 104
   :ENOTSOCK 38
   :ENOTSUP 45
   :ENOTTY 25
   :ENXIO 6
   :EOPNOTSUPP 102
   :EOVERFLOW 84
   :EOWNERDEAD 105
   :EPERM 1
   :EPFNOSUPPORT 46
   :EPIPE 32
   :EPROTO 100
   :EPROTONOSUPPORT 43
   :EPROTOTYPE 41
   :ERANGE 34
   :EREMOTE 71
   :ERESTART 318
   :EROFS 30
   :ESHUTDOWN 58
   :ESOCKTNOSUPPORT 44
   :ESPIPE 29
   :ESRCH 3
   :ESTALE 70
   :ETIME 101
   :ETIMEDOUT 60
   :ETOOMANYREFS 59
   :ETXTBSY 26
   :EUSERS 68
   :EXDEV 18
   :FD_CLOEXEC 1
   :F_GETFD 1
   :F_GETFL 3
   :F_GETLK 7
   :F_OK 0
   :F_RDLCK 1
   :F_SETFD 2
   :F_SETFL 4
   :F_SETLK 8
   :F_SETLKW 9
   :F_UNLCK 2
   :F_WRLCK 3
   :IPPROTO_ICMP 1
   :IPPROTO_IP 0
   :IPPROTO_RAW 255
   :IPPROTO_TCP 6
   :IPPROTO_UDP 17
   :IP_HDRINCL 2
   :IP_MTU 0
   :IP_TOS 3
   :IP_TTL 4
   :ITIMER_PROF 2
   :ITIMER_REAL 0
   :ITIMER_VIRTUAL 1
   :LOG_ALERT 1
   :LOG_CRIT 2
   :LOG_DEBUG 7
   :LOG_EMERG 0
   :LOG_ERR 3
   :LOG_INFO 6
   :LOG_NOTICE 5
   :LOG_WARNING 4
   :MSG_DONTROUTE 4
   :MSG_MORE 0
   :MSG_NOSIGNAL 524288
   :MSG_OOB 1
   :MSG_PEEK 2
   :MSG_WAITALL 64
   :NAME_MAX 255
   :NSIG 32
   :O_ACCMODE 3
   :O_APPEND 8
   :O_ASYNC 64
   :O_CLOEXEC 16777216
   :O_COMPRESSED 0
   :O_CREAT 512
   :O_DIRECT -1
   :O_DIRECTORY 1048576
   :O_DSYNC 4194304
   :O_EXCL 2048
   :O_EXEC 1073741824
   :O_EXLOCK 32
   :O_INDEXED 0
   :O_LARGEFILE 0
   :O_NOATIME 0
   :O_NOCTTY 131072
   :O_NOFOLLOW 256
   :O_NONBLOCK 4
   :O_PATH -1
   :O_RANDOM 0
   :O_RDONLY 0
   :O_RDWR 2
   :O_RSYNC -1
   :O_SEARCH 1074790400
   :O_SEQUENTIAL 0
   :O_SHLOCK 16
   :O_SYNC 128
   :O_TMPFILE -1
   :O_TRUNC 1024
   :O_UNLINK 1073741824
   :O_VERIFY -1
   :O_WRONLY 1
   :PATH_MAX 1024
   :PIPE_BUF 512
   :PLEDGE_PENALTY_KILL_PROCESS 1
   :PLEDGE_PENALTY_KILL_THREAD 0
   :PLEDGE_PENALTY_RETURN_EPERM 2
   :PLEDGE_STDERR_LOGGING 16
   :POLLERR 8
   :POLLHUP 16
   :POLLIN 1
   :POLLNVAL 32
   :POLLOUT 4
   :POLLPRI 2
   :POLLRDBAND 128
   :POLLRDHUP 16
   :POLLRDNORM 64
   :POLLWRBAND 256
   :POLLWRNORM 4
   :RLIMIT_AS 5
   :RLIMIT_CPU 0
   :RLIMIT_FSIZE 1
   :RLIMIT_NOFILE 8
   :RLIMIT_NPROC 7
   :RLIMIT_RSS 5
   :RUSAGE_BOTH 99
   :RUSAGE_CHILDREN -1
   :RUSAGE_SELF 0
   :RUSAGE_THREAD 99
   :R_OK 4
   :SA_NOCLDSTOP 8
   :SA_NOCLDWAIT 32
   :SA_NODEFER 16
   :SA_RESETHAND 4
   :SA_RESTART 2
   :SEEK_CUR 1
   :SEEK_END 2
   :SEEK_SET 0
   :SHUT_RD 0
   :SHUT_RDWR 2
   :SHUT_WR 1
   :SIGABRT 6
   :SIGALRM 14
   :SIGBUS 10
   :SIGCHLD 20
   :SIGCONT 19
   :SIGEMT 7
   :SIGFPE 8
   :SIGHUP 1
   :SIGILL 4
   :SIGINFO 29
   :SIGINT 2
   :SIGIO 23
   :SIGKILL 9
   :SIGPIPE 13
   :SIGPROF 27
   :SIGPWR 30
   :SIGQUIT 3
   :SIGRTMAX 0
   :SIGRTMIN 0
   :SIGSEGV 11
   :SIGSTKFLT 0
   :SIGSTOP 17
   :SIGSYS 12
   :SIGTERM 15
   :SIGTHR 7
   :SIGTRAP 5
   :SIGTSTP 18
   :SIGTTIN 21
   :SIGTTOU 22
   :SIGURG 16
   :SIGUSR1 30
   :SIGUSR2 31
   :SIGVTALRM 26
   :SIGWINCH 28
   :SIGXCPU 24
   :SIGXFSZ 25
   :SIG_BLOCK 1
   :SIG_DFL 0
   :SIG_IGN 1
   :SIG_SETMASK 3
   :SIG_UNBLOCK 2
   :SOCK_CLOEXEC 524288
   :SOCK_DGRAM 2
   :SOCK_NONBLOCK 2048
   :SOCK_RAW 3
   :SOCK_RDM 4
   :SOCK_SEQPACKET 5
   :SOCK_STREAM 1
   :SOL_IP 0
   :SOL_SOCKET 65535
   :SOL_TCP 6
   :SOL_UDP 17
   :SO_ACCEPTCONN 2
   :SO_BROADCAST 32
   :SO_DEBUG 1
   :SO_DONTROUTE 16
   :SO_ERROR 4103
   :SO_KEEPALIVE 8
   :SO_LINGER 4224
   :SO_RCVBUF 4098
   :SO_RCVLOWAT 4100
   :SO_RCVTIMEO 4102
   :SO_REUSEADDR 4
   :SO_REUSEPORT 512
   :SO_SNDBUF 4097
   :SO_SNDLOWAT 4099
   :SO_SNDTIMEO 4101
   :SO_TYPE 4104
   :ST_APPEND 0
   :ST_IMMUTABLE 0
   :ST_MANDLOCK 0
   :ST_NOATIME 268435456
   :ST_NODEV 16
   :ST_NODIRATIME 0
   :ST_NOEXEC 4
   :ST_NOSUID 8
   :ST_RDONLY 1
   :ST_RELATIME 0
   :ST_SYNCHRONOUS 2
   :ST_WRITE 0
   :TCP_CORK 4
   :TCP_DEFER_ACCEPT 0
   :TCP_FASTOPEN 261
   :TCP_FASTOPEN_CONNECT 0
   :TCP_KEEPCNT 258
   :TCP_KEEPIDLE 0
   :TCP_KEEPINTVL 257
   :TCP_MAXSEG 2
   :TCP_NODELAY 1
   :TCP_NOTSENT_LOWAT 513
   :TCP_QUICKACK 0
   :TCP_SAVED_SYN 0
   :TCP_SAVE_SYN 0
   :TCP_SYNCNT 0
   :TCP_WINDOW_CLAMP 0
   :UTIME_NOW -1
   :UTIME_OMIT -2
   :WNOHANG 1
   :W_OK 2
   :X_OK 1
  }})

(fn redbean.on-http-request []
  "Hooks HTTP message handling.

If this function is defined in the global scope by your `/.init.lua`
then redbean will call it at the earliest possible moment to
hand over control for all messages (with the exception of `OPTIONS--*`
See functions like `Route` which asks redbean to do its default
thing from the handler.
"
  (_G.OnHttpRequest ))

(fn redbean.on-error [status message]
  "Hooks catch errors

If this functiopn is defined in the global scope by your `/.init.lua`
then any errors occuring in the OnHttpRequest() hook will be catched.
You'll be able then to do whatever you need with the error status and
error message.

@param status uint16
@param message string"
  (_G.OnError status message))

(fn redbean.on-client-connection [ip port serverip serverport]
  "Hooks client connection creation.

If this function is defined it'll be called from the main process
each time redbean accepts a new client connection.

@param ip uint32
@param port uint16
@param serverip uint32
@param serverport uint16
@return boolean # If it returns `true`, redbean will close the connection without calling `fork`."
  (_G.OnClientConnection ip port serverip serverport))

(fn redbean.on-log-latency [reqtimeus contimeus]
  "Hook latency logging.

If this function is defined it'll be called from the main process
each time redbean completes handling of a request, but before the
response is sent. The handler received the time (in µs) since the
request handling and connection handling started.

@param reqtimeus integer
@param contimeus integer"
  (_G.OnLogLatency reqtimeus contimeus))

(fn redbean.on-process-create [pid ip port serverip serverport]
  "Hooks process creation.

If this function is defined it'll be called from the main process
each time redbean forks a connection handler worker process. The
ip/port of the remote client is provided, along with the ip/port
of the listening interface that accepted the connection. This may
be used to create a server activity dashboard, in which case the
data provider handler should set `SetHeader('Connection','Close')`.
This won't be called in uniprocess mode.

@param pid integer
@param ip uint32
@param port uint16
@param serverip uint32
@param serverport uint16"
  (_G.OnProcessCreate pid ip port serverip serverport))

(fn redbean.on-process-destroy [pid]
  "If this function is defined it'll be called from the main process
each time redbean reaps a child connection process using `wait4()`.
This won't be called in uniprocess mode.
@param pid integer"
  (_G.OnProcessDestroy pid))

(fn redbean.on-server-heartbeat []
  "If this function is defined it'll be called from the main process
on each server heartbeat. The heartbeat interval is configurable
with `ProgramHeartbeatInterval`."
  (_G.OnServerHeartbeat ))

(fn redbean.on-server-listen [socketdescriptor serverip serverport]
  "If this function is defined it'll be called from the main process
before redbean starts listening on a port. This hook can be used
to modify socket configuration to set `SO_REUSEPORT`, for example.
@param socketdescriptor integer
@param serverip uint32
@param serverport uint16
@return boolean ignore If `true`, redbean will not listen to that ip/port."
  (_G.OnServerListen socketdescriptor serverip serverport))

(fn redbean.on-server-reload [reindex]
  "If this function is defined it'll be called from the main process
on each server reload triggered by SIGHUP (for daemonized) and
SIGUSR1 (for all) redbean instances. `reindex` indicates if redbean
assets have been re-indexed following the signal.
@param reindex boolean"
  (_G.OnServerReload reindex))

(fn redbean.on-server-start []
  "If this function is defined it'll be called from the main process
right before the main event loop starts."
  (_G.OnServerStart ))

(fn redbean.on-server-stop []
  "If this function is defined it'll be called from the main process
after all the connection processes have been reaped and `exit()` is
ready to be called."
  (_G.OnServerStop ))

(fn redbean.on-worker-start []
  "If this function is defined it'll be called from the child worker
process after it's been forked and before messages are handled.
This won't be called in uniprocess mode."
  (_G.OnWorkerStart ))

(fn redbean.write [data]
  "Appends data to HTTP response payload buffer.

This is buffered independently of headers.

@param data string"
  (_G.Write data))

(fn redbean.set-status [code reason]
  "Starts an HTTP response, specifying the parameters on its first line.

This method will reset the response and is therefore mutually
exclusive with `ServeAsset` and other `Serve*` functions. If a
status setting function isn't called, then the default behavior is
to send `200 OK`.

@param code integer
@param reason? string is optional since redbean can fill in the appropriate text for well-known magic numbers, e.g. `200`, `404`, etc."
  (_G.SetStatus code reason))

(fn redbean.set-header [name value]
  "Appends HTTP header to response header buffer.

Leading and trailing whitespace is trimmed automatically. Overlong
characters are canonicalized. C0 and C1 control codes are forbidden,
with the exception of tab. This function automatically calls
`SetStatus(200, \"OK\")` if a status has not yet been set. As
`SetStatus` and `Serve*` functions reset the response, `SetHeader`
needs to be called after `SetStatus` and `Serve*` functions are
called. The header buffer is independent of the payload buffer.
Neither is written to the wire until the Lua Server Page has
finished executing. This function disallows the setting of certain
headers such as and Content-Range which are abstracted by the
transport layer. In such cases, consider calling `ServeAsset`.

@param name string is case-insensitive and restricted to non-space ASCII
@param value string is a UTF-8 string that must be encodable as ISO-8859-1."
  (_G.SetHeader name value))

(fn redbean.set-cookie [name value options]
  "Appends Set-Cookie HTTP header to the response header buffer.

Several Set-Cookie headers can be added to the same response.
`__Host-` and `__Secure-` prefixes are supported and may set or
overwrite some of the options (for example, specifying `__Host-`
prefix sets the Secure option to `true`, sets the path to `\"/\"`, and
removes the Domain option). The following options can be used (their
lowercase equivalents are supported as well):

- `Expires` sets the maximum lifetime of the cookie as an HTTP-date timestamp. Can be specified as a Date in the RFC1123 (string) format or as a UNIX timestamp (number of seconds).
- `MaxAge` sets number of seconds until the cookie expires. A zero or negative number will expire the cookie immediately. If both Expires and MaxAge are set, MaxAge has precedence.
- `Domain` sets the host to which the cookie will be sent.
- `Path` sets the path that must be present in the request URL, or the client will not send the Cookie header.
- `Secure` (boolean) requests the cookie to be only send to the server when a request is made with the https: scheme.
- `HttpOnly` (boolean) forbids JavaScript from accessing the cookie.
- `SameSite` (Strict, Lax, or None) controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks.

@param name string
@param value string
@param options { Expires: string|integer?, MaxAge: integer?, Domain: string?, Path: string?, Secure: boolean?, HttpOnly: boolean?, SameSite: \"Strict\"|\"Lax\"|\"None\"? }?"
  (_G.SetCookie name value options))

(fn redbean.get-param [name]
  "Returns first value associated with name. name is handled in a case-sensitive manner. This function checks Request-URL parameters first. Then it checks `application/x-www-form-urlencoded` from the message body, if it exists, which is common for HTML forms sending `POST` requests. If a parameter is supplied matching name that has no value, e.g. `foo` in `?foo&bar=value`, then the returned value will be `nil`, whereas for `?foo=&bar=value` it would be `\"\"`. To differentiate between no-equal and absent, use the `HasParam` function. The returned value is decoded from ISO-8859-1 (only in the case of Request-URL) and we assume that percent-encoded characters were supplied by the client as UTF-8 sequences, which are returned exactly as the client supplied them, and may therefore may contain overlong sequences, control codes, `NUL` characters, and even numbers which have been banned by the IETF. It is the responsibility of the caller to impose further restrictions on validity, if they're desired.
@param name string
@return string value
@nodiscard"
  (_G.GetParam name))

(fn redbean.escape-html [str]
  "Escapes HTML entities: The set of entities is `&><\"'` which become `&amp;&gt;&lt;&quot;&#39;`. This function is charset agnostic and will not canonicalize overlong encodings. It is assumed that a UTF-8 string will be supplied. See `escapehtml.c`.
@param str string
@return string
@nodiscard"
  (_G.EscapeHtml str))

(fn redbean.launch-browser [path]
  "Launches web browser on local machine with URL to this redbean server. This function may be called from your `/.init.lua`.
@param path string?"
  (_G.LaunchBrowser path))

(fn redbean.categorize-ip [ip]
  "@param ip uint32
@return string # a string describing the IP address. This is currently Class A granular. It can tell you if traffic originated from private networks, ARIN, APNIC, DOD, etc.
@nodiscard"
  (_G.CategorizeIp ip))

(fn redbean.decode-latin1 [iso_8859_1]
  "Turns ISO-8859-1 string into UTF-8.
@param iso_8859_1 string
@return string UTF8
@nodiscard"
  (_G.DecodeLatin1 iso_8859_1))

(fn redbean.encode-hex [binary]
  "Turns binary into ASCII base-16 hexadecimal lowercase string.
@param binary string
@return string ascii"
  (_G.EncodeHex binary))

(fn redbean.decode-hex [ascii]
  "Turns ASCII base-16 hexadecimal byte string into binary string,
case-insensitively. Non-hex characters may not appear in string.
@param ascii string
@return string binary"
  (_G.DecodeHex ascii))

(fn redbean.decode-base64 [ascii]
  "Decodes binary data encoded as base64.

This turns ASCII into binary, in a permissive way that ignores
characters outside the base64 alphabet, such as whitespace. See
`decodebase64.c`.

@param ascii string
@return string binary
@nodiscard"
  (_G.DecodeBase64 ascii))

(fn redbean.encode-base64 [binary]
  "Turns binary into ASCII. This can be used to create HTML data:
URIs that do things like embed a PNG file in a web page. See
encodebase64.c.
@param binary string
@return string ascii
@nodiscard"
  (_G.EncodeBase64 binary))

(fn redbean.decode-json [input]
  "@alias JsonEl<T> string|number|boolean|nil|{ [integer]: T }|{ [string]: T }
@alias JsonValue JsonEl<JsonEl<JsonEl<JsonEl<JsonEl<JsonEl<JsonEl<any>>>>>>>
Turns JSON string into a Lua data structure.

This is a generally permissive parser, in the sense that like
v8, it permits scalars as top-level values. Therefore we must
note that this API can be thought of as special, in the sense

    val = assert(DecodeJson(str))

will usually do the right thing, except in cases where `false`
or `null` are the top-level value. In those cases, it's needed
to check the second value too in order to discern from error

    val, err = DecodeJson(str)
    if not val then
       if err then
          print('bad json', err)
       elseif val == nil then
          print('val is null')
       elseif val == false then
          print('val is false')
       end
    end

This parser supports 64-bit signed integers. If an overflow
happens, then the integer is silently coerced to double, as
consistent with v8. If a double overflows into `Infinity`, we
coerce it to `null` since that's what v8 does, and the same
goes for underflows which, like v8, are coerced to `0.0`.

When objects are parsed, your Lua object can't preserve the
original ordering of fields. As such, they'll be sorted by
`EncodeJson()` and may not round-trip with original intent.

This parser has perfect conformance with JSONTestSuite.

This parser validates utf-8 and utf-16.
@param input string
@return JsonValue
@nodiscard
@overload fun(input: string): nil, error: string"
  (_G.DecodeJson input))

(fn redbean.encode-json [value options]
  "Turns Lua data structure into JSON string.

Since Lua uses tables are both hashmaps and arrays, we use a
simple fast algorithm for telling the two apart. Tables with
non-zero length (as reported by `#`) are encoded as arrays,
and any non-array elements are ignored. For example:

    >: EncodeJson({2})
    \"[2]\"
    >: EncodeJson({[1]=2, [\"hi\"]=1})
    \"[2]\"

If there are holes in your array, then the serialized array
will exclude everything after the first hole. If the beginning
of your array is a hole, then an error is returned.

    >: EncodeJson({[1]=1, [3]=3})
    \"[1]\"
    >: EncodeJson({[2]=1, [3]=3})
    \"[]\"
    >: EncodeJson({[2]=1, [3]=3})
    nil     \"json objects must only use string keys\"

If the raw length of a table is reported as zero, then we
check for the magic element `[0]=false`. If it's present, then
your table will be serialized as empty array `[]`. An entry is
inserted by `DecodeJson()` automatically, only when encountering
empty arrays, and it's necessary in order to make empty arrays
round-trip. If raw length is zero and `[0]=false` is absent,
then your table will be serialized as an iterated object.

    >: EncodeJson({})
    \"{}\"
    >: EncodeJson({[0]=false})
    \"[]\"
    >: EncodeJson({[\"hi\"]=1})
    \"{\\\"hi\\\":1}\"
    >: EncodeJson({[\"hi\"]=1, [0]=false})
    \"[]\"
    >: EncodeJson({[\"hi\"]=1, [7]=false})
    nil     \"json objects must only use string keys\"

The following options may be used:

- `useoutput`: `(bool=false)` encodes the result directly to the output buffer
  and returns nil value. This option is ignored if used outside of request
  handling code.
- `sorted`: `(bool=true)` Lua uses hash tables so the order of object keys is
  lost in a Lua table. So, by default, we use strcmp to impose a deterministic
  output order. If you don't care about ordering then setting `sorted=false`
  should yield a performance boost in serialization.
- `pretty`: `(bool=false)` Setting this option to true will cause tables with
  more than one entry to be formatted across multiple lines for readability.
- `indent`: `(str=\" \")` This option controls the indentation of pretty
   formatting. This field is ignored if pretty isn't `true`.
- `maxdepth`: `(int=64)` This option controls the maximum amount of recursion
  the serializer is allowed to perform. The max is 32767. You might not be able
  to set it that high if there isn't enough C stack memory. Your serializer
  checks for this and will return an error rather than crashing.

If the raw length of a table is reported as zero, then we
check for the magic element `[0]=false`. If it's present, then
your table will be serialized as empty array `[]`. An entry is
inserted by `DecodeJson()` automatically, only when encountering
empty arrays, and it's necessary in order to make empty arrays
round-trip. If raw length is zero and `[0]=false` is absent,
then your table will be serialized as an iterated object.

This function will return an error if:

- value is cyclic
- value has depth greater than 64
- value contains functions, user data, or threads
- value is table that blends string / non-string keys
- Your serializer runs out of C heap memory (setrlimit)

We assume strings in value contain UTF-8. This serializer currently does not
produce UTF-8 output. The output format is right now ASCII. Your UTF-8 data
will be safely transcoded to `\\uXXXX` sequences which are UTF-16. Overlong
encodings in your input strings will be canonicalized rather than validated.

NaNs are serialized as `null` and Infinities are `null` which is consistent
with the v8 behavior.
@param value JsonValue
@param options { useoutput: false?, sorted: boolean?, pretty: boolean?, indent: string?, maxdepth: integer? }?
@return string
@nodiscard
@overload fun(value: JsonValue, options: { useoutput: true, sorted: boolean?, pretty: boolean?, indent: string?, maxdepth: integer? }): true
@overload fun(value: JsonValue, options: { useoutput: boolean?, sorted: boolean?, pretty: boolean?, indent: string?, maxdepth: integer? }? ): nil, error: string"
  (_G.EncodeJson value options))

(fn redbean.encode-lua [value options]
  "Turns Lua data structure into Lua code string.

Since Lua uses tables as both hashmaps and arrays, tables will only be
serialized as an array with determinate order, if it's an array in the
strictest possible sense.

1. for all 𝑘=𝑣 in table, 𝑘 is an integer ≥1
2. no holes exist between MIN(𝑘) and MAX(𝑘)
3. if non-empty, MIN(𝑘) is 1

In all other cases, your table will be serialized as an object which is
iterated and displayed as a list of (possibly) sorted entries that have
equal signs.

    >: EncodeLua({3, 2})
    \"{3, 2}\"
    >: EncodeLua({[1]=3, [2]=3})
    \"{3, 2}\"
    >: EncodeLua({[1]=3, [3]=3})
    \"{[1]=3, [3]=3}\"
    >: EncodeLua({[\"hi\"]=1, [1]=2})
    \"{[1]=2, hi=1}\"

The following options may be used:

- `useoutput`: `(bool=false)` encodes the result directly to the output buffer
  and returns nil value. This option is ignored if used outside of request
  handling code.
- `sorted`: `(bool=true)` Lua uses hash tables so the order of object keys is
  lost in a Lua table. So, by default, we use strcmp to impose a deterministic
  output order. If you don't care about ordering then setting `sorted=false`
  should yield a performance boost in serialization.
- `pretty`: `(bool=false)` Setting this option to true will cause tables with
  more than one entry to be formatted across multiple lines for readability.
- `indent`: `(str=\" \")` This option controls the indentation of pretty
   formatting. This field is ignored if pretty isn't `true`.
- `maxdepth`: `(int=64)` This option controls the maximum amount of recursion
  the serializer is allowed to perform. The max is 32767. You might not be able
  to set it that high if there isn't enough C stack memory. Your serializer
  checks for this and will return an error rather than crashing.

If a user data object has a `__repr` or `__tostring` meta method, then that'll
be used to encode the Lua code.

This serializer is designed primarily to describe data. For example, it's used
by the REPL where we need to be able to ignore errors when displaying data
structures, since showing most things imperfectly is better than crashing.
Therefore this isn't the kind of serializer you'd want to use to persist data
in prod. Try using the JSON serializer for that purpose.

Non-encodable value types (e.g. threads, functions) will be represented as a
string literal with the type name and pointer address. The string description
is of an unspecified format that could most likely change. This encoder detects
cyclic tables; however instead of failing, it embeds a string of unspecified
layout describing the cycle.

Integer literals are encoded as decimal. However if the int64 number is ≥256
and has a population count of 1 then we switch to representating the number in
hexadecimal, for readability. Hex numbers have leading zeroes added in order
to visualize whether the number fits in a uint16, uint32, or int64. Also some
numbers can only be encoded expressionally. For example, `NaN`s are serialized
as `0/0`, and `Infinity` is `math.huge`.

    >: 7000
    7000
    >: 0x100
    0x0100
    >: 0x10000
    0x00010000
    >: 0x100000000
    0x0000000100000000
    >: 0/0
    0/0
    >: 1.5e+9999
    math.huge
    >: -9223372036854775807 - 1
    -9223372036854775807 - 1

The only failure return condition currently implemented is when C runs out of heap memory.
@param options { useoutput: false?, sorted: boolean?, pretty: boolean?, indent: string?, maxdepth: integer? }?
@return string
@nodiscard
@overload fun(value, options: { useoutput: true, sorted: boolean?, pretty: boolean?, indent: string?, maxdepth: integer? }): true
@overload fun(value, options: EncoderOptions? ): nil, error: string"
  (_G.EncodeLua value options))

(fn redbean.encode-latin1 [utf8 flags]
  "Turns UTF-8 into ISO-8859-1 string.
@param utf8 string
@param flags integer
@return string iso_8859_1
@nodiscard"
  (_G.EncodeLatin1 utf8 flags))

(fn redbean.escape-fragment [str]
  "Escapes URL #fragment. The allowed characters are `-/?.~_@:!$&'()*+,;=0-9A-Za-z`
and everything else gets `%XX` encoded. Please note that `'&` can still break
HTML and that `'()` can still break CSS URLs. This function is charset agnostic
and will not canonicalize overlong encodings. It is assumed that a UTF-8 string
will be supplied. See `kescapefragment.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapeFragment str))

(fn redbean.escape-host [str]
  "Escapes URL host. See `kescapeauthority.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapeHost str))

(fn redbean.escape-literal [str]
  "Escapes JavaScript or JSON string literal content. The caller is responsible
for adding the surrounding quotation marks. This implementation \\uxxxx sequences
for all non-ASCII sequences. HTML entities are also encoded, so the output
doesn't need `EscapeHtml`. This function assumes UTF-8 input. Overlong
encodings are canonicalized. Invalid input sequences are assumed to
be ISO-8859-1. The output is UTF-16 since that's what JavaScript uses. For
example, some individual codepoints such as emoji characters will encode as
multiple `\\uxxxx` sequences. Ints that are impossible to encode as UTF-16 are
substituted with the `\\xFFFD` replacement character.
See `escapejsstringliteral.c`.
@param str string
@return string
@nodiscard"
  (_G.EscapeLiteral str))

(fn redbean.escape-param [str]
  "Escapes URL parameter name or value. The allowed characters are `-.*_0-9A-Za-z`
and everything else gets `%XX` encoded. This function is charset agnostic and
will not canonicalize overlong encodings. It is assumed that a UTF-8 string
will be supplied. See `kescapeparam.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapeParam str))

(fn redbean.escape-pass [str]
  "Escapes URL password. See `kescapeauthority.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapePass str))

(fn redbean.escape-path [str]
  "Escapes URL path. This is the same as EscapeSegment except slash is allowed.
The allowed characters are `-.~_@:!$&'()*+,;=0-9A-Za-z/` and everything else
gets `%XX` encoded. Please note that `'&` can still break HTML, so the output
may need EscapeHtml too. Also note that `'()` can still break CSS URLs. This
function is charset agnostic and will not canonicalize overlong encodings.
It is assumed that a UTF-8 string will be supplied. See `kescapepath.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapePath str))

(fn redbean.escape-segment [str]
  "Escapes URL path segment. This is the same as EscapePath except slash isn't
allowed. The allowed characters are `-.~_@:!$&'()*+,;=0-9A-Za-z` and everything
else gets `%XX` encoded. Please note that `'&` can still break HTML, so the
output may need EscapeHtml too. Also note that `'()` can still break CSS URLs.
This function is charset agnostic and will not canonicalize overlong encodings.
It is assumed that a UTF-8 string will be supplied. See `kescapesegment.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapeSegment str))

(fn redbean.escape-user [str]
  "Escapes URL username. See `kescapeauthority.S`.
@param str string
@return string
@nodiscard"
  (_G.EscapeUser str))

(fn redbean.evade-dragnet-surveillance [bool]
  "If this option is programmed then redbean will not transmit a Server Name
Indicator (SNI) when performing `Fetch()` requests. This function is not
available in unsecure mode.
@param bool boolean"
  (_G.EvadeDragnetSurveillance bool))

(fn redbean.fetch [url body]
  "Sends an HTTP/HTTPS request to the specified URL. If only the URL is provided,
then a GET request is sent. If both URL and body parameters are specified, then
a POST request is sent. If any other method needs to be specified (for example,
PUT or DELETE), then passing a table as the second value allows setting method
and body values as well other options:

- `method` (default: `\"GET\"`): sets the method to be used for the request.
  The specified method is converted to uppercase.
- `body` (default: `\"\"`): sets the body value to be sent.
- `followredirect` (default: `true`): forces temporary and permanent redirects
   to be followed. This behavior can be disabled by passing `false`.
- `maxredirects` (default: `5`): sets the number of allowed redirects to
  minimize looping due to misconfigured servers. When the number is exceeded,
  the result of the last redirect is returned.
- `keepalive` (default = `false`): configures each request to keep the
  connection open (unless closed by the server) and reuse for the
  next request to the same host. This option is disabled when SSL
  connection is used.
  The mapping of hosts and their sockets is stored in a table
  assigned to the `keepalive` field itself, so it can be passed to
  the next call.
  If the table includes the `close` field set to a true value,
  then the connection is closed after the request is made and the
  host is removed from the mapping table.

When the redirect is being followed, the same method and body values are being
sent in all cases except when 303 status is returned. In that case the method
is set to GET and the body is removed before the redirect is followed. Note
that if these (method/body) values are provided as table fields, they will be
modified in place.
@param url string
@param body? string|{ headers: table<string,string>, value: string, method: string, body: string, maxredirects: integer?, keepalive: boolean? }
@return integer status, table<string,string> headers, string body/
@nodiscard
@overload fun(url:string, body?: string|{ headers: table<string,string>, value: string, method: string, body: string, maxredirects?: integer, keepalive: boolean? }): nil, error: string"
  (_G.Fetch url body))

(fn redbean.format-http-date-time [seconds]
  "Converts UNIX timestamp to an RFC1123 string that looks like this:
`Mon, 29 Mar 2021 15:37:13 GMT`. See `formathttpdatetime.c`.
@param seconds integer
@return string
@nodiscard rfc1123"
  (_G.FormatHttpDateTime seconds))

(fn redbean.format-ip [uint32]
  "Turns integer like `0x01020304` into a string like `\"1.2.3.4\"`. See also
`ParseIp` for the inverse operation.
@param uint32 integer
@return string
@nodiscard"
  (_G.FormatIp uint32))

(fn redbean.get-remote-addr []
  "Returns client ip4 address and port, e.g. `0x01020304`,`31337` would represent
`1.2.3.4:31337`. This is the same as `GetClientAddr` except it will use the
ip:port from the `X-Forwarded-For` header, only if `IsPrivateIp` or
`IsPrivateIp` returns `true`.
@return integer ip, integer port uint32 and uint16 respectively
@nodiscard"
  (_G.GetRemoteAddr ))

(fn redbean.get-response-body []
  "@return string
@nodiscard # the response message body if present or an empty string. Also
returns an empty string during streaming."
  (_G.GetResponseBody ))

(fn redbean.get-client-addr []
  "Returns client socket ip4 address and port, e.g. `0x01020304,31337` would
represent `1.2.3.4:31337`. Please consider using `GetRemoteAddr` instead,
since the latter takes into consideration reverse proxy scenarios.
@return uint32 ip uint32
@return uint16 port uint16
@nodiscard"
  (_G.GetClientAddr ))

(fn redbean.get-server-addr []
  "Returns address to which listening server socket is bound, e.g.
`0x01020304,8080` would represent `1.2.3.4:8080`. If `-p 0` was supplied as
the listening port, then the port in this string will be whatever number the
operating system assigned.
@return uint32 ip uint32
@return uint16 port uint16
@nodiscard"
  (_G.GetServerAddr ))

(fn redbean.get-client-fd []
  "@return integer clientfd
@nodiscard"
  (_G.GetClientFd ))

(fn redbean.get-date []
  "@return integer unixts date associated with request that's used to generate the
Date header, which is now, give or take a second. The returned value is a UNIX
timestamp.
@nodiscard"
  (_G.GetDate ))

(fn redbean.get-fragment []
  "@return string?
@nodiscard"
  (_G.GetFragment ))

(fn redbean.get-header [name]
  "Returns HTTP header. name is case-insensitive. The header value is returned as
a canonical UTF-8 string, with leading and trailing whitespace trimmed, which
was decoded from ISO-8859-1, which is guaranteed to not have C0/C1 control
sequences, with the exception of the tab character. Leading and trailing
whitespace is automatically removed. In the event that the client suplies raw
UTF-8 in the HTTP message headers, the original UTF-8 sequence can be
losslessly restored by counter-intuitively recoding the returned string back
to Latin1. If the requested header is defined by the RFCs as storing
comma-separated values (e.g. Allow, Accept-Encoding) and the field name occurs
multiple times in the message, then this function will fold those multiple
entries into a single string.
@param name string
@return string
@nodiscard value"
  (_G.GetHeader name))

(fn redbean.get-headers []
  "Returns HTTP headers as dictionary mapping header key strings to their UTF-8
decoded values. The ordering of headers from the request message is not
preserved. Whether or not the same key can repeat depends on whether or not
it's a standard header, and if so, if it's one of the ones that the RFCs
define as repeatable. See `khttprepeatable.c`. Those headers will not be
folded. Standard headers which aren't on that list, will be overwritten with
the last-occurring one during parsing. Extended headers are always passed
through exactly as they're received. Please consider using `GetHeader` API if
possible since it does a better job abstracting these issues.
@return table<string, string>
@nodiscard"
  (_G.GetHeaders ))

(fn redbean.get-log-level []
  "Returns logger verbosity level. Likely return values are `kLogDebug` >
`kLogVerbose` > `kLogInfo` > `kLogWarn` > `kLogError` > `kLogFatal`.
@return integer
@nodiscard"
  (_G.GetLogLevel ))

(fn redbean.get-host []
  "@return string # host associated with request. This will be the Host header, if it's supplied. Otherwise it's the bind address.
@nodiscard"
  (_G.GetHost ))

(fn redbean.get-host-os []
  "@return \"LINUX\"|\"METAL\"|\"WINDOWS\"|\"XNU\"|\"NETBSD\"|\"FREEBSD\"|\"OPENBSD\" osname string that describes the host OS.
@nodiscard"
  (_G.GetHostOs ))

(fn redbean.get-host-isa []
  "Returns string describing host instruction set architecture.

This can return:

- `\"X86_64\"` for Intel and AMD systems
- `\"AARCH64\"` for ARM64, M1, and Raspberry Pi systems
- `\"POWERPC64\"` for OpenPOWER Raptor Computing Systems
@return \"X86_64\"|\"AARCH64\"|\"POWERPC64\"
@nodiscard"
  (_G.GetHostIsa ))

(fn redbean.get-monospace-width [str]
  "@param str string|integer monospace display width of string.
This is useful for fixed-width formatting. For example, CJK characters
typically take up two cells. This function takes into consideration combining
characters, which are discounted, as well as control codes and ANSI escape
sequences.
@return integer
@nodiscard"
  (_G.GetMonospaceWidth str))

(fn redbean.get-method []
  "@return string method HTTP method.
Normally this will be GET, HEAD, or POST in which case redbean normalizes this
value to its uppercase form. Anything else that the RFC classifies as a \"token\"
string is accepted too, which might contain characters like &\".
@nodiscard"
  (_G.GetMethod ))

(fn redbean.get-params []
  "@return { [1]: string, [2]: string? }[] # name=value parameters from Request-URL and `application/x-www-form-urlencoded` message body in the order they were received.
This may contain duplicates. The inner array will have either one or two items,
depending on whether or not the equals sign was used.
@nodiscard"
  (_G.GetParams ))

(fn redbean.get-pass []
  "@return string? pass
@nodiscard"
  (_G.GetPass ))

(fn redbean.get-path []
  "@return string path the Request-URL path.
This is guaranteed to begin with `\"/\"` It is further guaranteed that no `\"//\"`
or `\"/.\"` exists in the path. The returned value is returned as a UTF-8 string
 which was decoded from ISO-8859-1. We assume that percent-encoded characters
were supplied by the client as UTF-8 sequences, which are returned exactly as
the client supplied them, and may therefore may contain overlong sequences,
control codes, `NUL` characters, and even numbers which have been banned by
the IETF. redbean takes those things into consideration when performing path
safety checks. It is the responsibility of the caller to impose further
restrictions on validity, if they're desired.
@nodiscard"
  (_G.GetPath ))

(fn redbean.get-effective-path []
  "@return string path as it was resolved by the routing algorithms, which might contain the virtual host prepended if used.
@nodiscard"
  (_G.GetEffectivePath ))

(fn redbean.get-port []
  "@return uint16 port
@nodiscard"
  (_G.GetPort ))

(fn redbean.get-scheme []
  "@return string? scheme from Request-URL, if any.
@nodiscard"
  (_G.GetScheme ))

(fn redbean.get-status []
  "@return integer? current status (as set by an earlier `SetStatus` call) or `nil` if the status hasn't been set yet.
@nodiscard"
  (_G.GetStatus ))

(fn redbean.get-time []
  "@return number seconds current time as a UNIX timestamp with 0.0001s precision.
@nodiscard"
  (_G.GetTime ))

(fn redbean.get-url []
  "@return string url the effective Request-URL as an ASCII string
Illegal characters or UTF-8 is guaranteed to be percent encoded, and has been
normalized to include either the Host or `X-Forwarded-Host` headers, if they
exist, and possibly a scheme too if redbean is being used as an HTTP proxy
server.

In the future this API might change to return an object instead.
@nodiscard"
  (_G.GetUrl ))

(fn redbean.get-user []
  "@return string? user
@nodiscard"
  (_G.GetUser ))

(fn redbean.get-http-version []
  "@return integer httpversion the request HTTP protocol version, which can be `9` for `HTTP/0.9`, `10` for `HTTP/1.0`, or `11` for `HTTP/1.1`.
@nodiscard"
  (_G.GetHttpVersion ))

(fn redbean.get-version []
  "@return integer
@nodiscard
@deprecated Use `GetHttpVersion` instead."
  (_G.GetVersion ))

(fn redbean.get-http-reason [code]
  "@param code integer
@return string reason string describing the HTTP reason phrase. See `gethttpreason.c`.
@nodiscard"
  (_G.GetHttpReason code))

(fn redbean.get-random-bytes [len]
  "@param length integer?
@return string # with the specified number of random bytes (1..256). If no length is specified, then a string of length 16 is returned.
@nodiscard"
  (_G.GetRandomBytes len))

(fn redbean.get-redbean-version []
  "@return integer redbeanversion the Redbean version in the format 0xMMmmpp, with major (MM), minor (mm), and patch (pp) versions encoded. The version value 1.4 would be represented as 0x010400.
@nodiscard"
  (_G.GetRedbeanVersion ))

(fn redbean.get-zip-paths [prefix]
  "@param prefix string? paths of all assets in the zip central directory, prefixed by a slash.
If prefix parameter is provided, then only paths that start with the prefix
(case sensitive) are returned.
@return string[]
@nodiscard"
  (_G.GetZipPaths prefix))

(fn redbean.has-param [name]
  "@param name string
@return boolean # `true` if parameter with name was supplied in either the Request-URL or an application/x-www-form-urlencoded message body.
@nodiscard"
  (_G.HasParam name))

(fn redbean.hide-path [prefix]
  "Programs redbean `/` listing page to not display any paths beginning with prefix.
This function should only be called from `/.init.lua`.
@param prefix string"
  (_G.HidePath prefix))

(fn redbean.is-hidden-path [path]
  "@param path string
@return boolean # `true` if the prefix of the given path is set with `HidePath`.
@nodiscard"
  (_G.IsHiddenPath path))

(fn redbean.is-public-ip [uint32]
  "@param uint32 integer
@return boolean # `true` if IP address is not a private network (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) and is not localhost (`127.0.0.0/8`).
Note: we intentionally regard TEST-NET IPs as public.
@nodiscard"
  (_G.IsPublicIp uint32))

(fn redbean.is-private-ip [uint32]
  "@param uint32 integer
@return boolean # `true` if IP address is part of a private network (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
@nodiscard"
  (_G.IsPrivateIp uint32))

(fn redbean.is-loopback-client []
  "@return boolean # `true` if the client IP address (returned by GetRemoteAddr) is part of the localhost network (127.0.0.0/8).
@nodiscard"
  (_G.IsLoopbackClient ))

(fn redbean.is-loopback-ip [uint32]
  "@param uint32 integer
@return boolean # true if IP address is part of the localhost network (127.0.0.0/8).
@nodiscard"
  (_G.IsLoopbackIp uint32))

(fn redbean.is-asset-compressed [path]
  "@param path string
@return boolean # `true` if ZIP artifact at path is stored on disk using DEFLATE compression.
@nodiscard"
  (_G.IsAssetCompressed path))

(fn redbean.is-compressed [path]
  "@deprecated use IsAssetCompressed instead.
@param path string
@return boolean
@nodiscard"
  (_G.IsCompressed path))

(fn redbean.is-client-using-ssl []
  "@return boolean
@nodiscard"
  (_G.IsClientUsingSsl ))

(fn redbean.indent-lines [str int]
  "Adds spaces to beginnings of multiline string. If the int parameter is not
supplied then 1 space will be added.
@param str string
@param int integer?
@return string
@nodiscard"
  (_G.IndentLines str int))

(fn redbean.load-asset [path]
  "@param path string
@return string asset contents of file as string.
The asset may be sourced from either the zip (decompressed) or the local
filesystem if the `-D` flag was used. If slurping large file into memory is a
concern, then consider using `ServeAsset` which can serve directly off disk.
@nodiscard"
  (_G.LoadAsset path))

(fn redbean.store-asset [path data mode]
  "Stores asset to executable's ZIP central directory. This currently happens in
 an append-only fashion and is still largely in the proof-of-concept stages.
Currently only supported on Linux, XNU, and FreeBSD. In order to use this
feature, the `-*` flag must be passed.
@param path string
@param data string
@param mode? integer"
  (_G.StoreAsset path data mode))

(fn redbean.log [level message]
  "Emits message string to log, if level is less than or equal to `GetLogLevel`.
If redbean is running in interactive mode, then this will log to the console.
If redbean is running as a daemon or the `-L LOGFILE` flag is passed, then this
will log to the file. Reasonable values for level are `kLogDebug` >
`kLogVerbose` > `kLogInfo` > `kLogWarn` > `kLogError` > `kLogFatal`. The
logger emits timestamps in the local timezone with microsecond precision. If
log entries are emitted more frequently than once per second, then the log
entry will display a delta timestamp, showing how much time has elapsed since
the previous log entry. This behavior is useful for quickly measuring how long
various portions of your code take to execute.
@param level integer
@param message string"
  (_G.Log level message))

(fn redbean.parse-http-date-time [rfc1123]
  "Converts RFC1123 string that looks like this: Mon, 29 Mar 2021 15:37:13 GMT to
a UNIX timestamp. See `parsehttpdatetime.c`.
@param rfc1123 string
@return integer seconds
@nodiscard"
  (_G.ParseHttpDateTime rfc1123))

(fn redbean.parse-url [url flags]
  "Parses URL.

@return Url url An object containing the following fields is returned:

- `scheme` is a string, e.g. `\"http\"`
- `user` is the username string, or nil if absent
- `pass` is the password string, or nil if absent
- `host` is the hostname string, or nil if `url` was a path
- `port` is the port string, or nil if absent
- `path` is the path string, or nil if absent
- `params` is the URL paramaters, e.g. `/?a=b&c` would be
  represented as the data structure `{{\"a\", \"b\"}, {\"c\"}, ...}`
- `fragment` is the stuff after the `#` character

@param url string
@param flags integer? may have:

- `kUrlPlus` to turn `+` into space
- `kUrlLatin1` to transcode ISO-8859-1 input into UTF-8

This parser is charset agnostic. Percent encoded bytes are
decoded for all fields. Returned values might contain things
like NUL characters, spaces, control codes, and non-canonical
encodings. Absent can be discerned from empty by checking if
the pointer is set.

There's no failure condition for this routine. This is a
permissive parser. This doesn't normalize path segments like
`.` or `..` so use IsAcceptablePath() to check for those. No
restrictions are imposed beyond that which is strictly
necessary for parsing. All the data that is provided will be
consumed to the one of the fields. Strict conformance is
enforced on some fields more than others, like scheme, since
it's the most non-deterministically defined field of them all.

Please note this is a URL parser, not a URI parser. Which
means we support everything the URI spec says we should do
except for the things we won't do, like tokenizing path
segments into an array and then nesting another array beneath
each of those for storing semicolon parameters. So this parser
won't make SIP easy. What it can do is parse HTTP URLs and most
URIs like data:opaque, better in fact than most things which
claim to be URI parsers.

@nodiscard"
  (_G.ParseUrl url flags))

(fn redbean.is-acceptable-path [str]
  "@param str string
@return boolean # `true` if path doesn't contain \".\", \"..\" or \"//\" segments See `isacceptablepath.c`
@nodiscard"
  (_G.IsAcceptablePath str))

(fn redbean.is-reasonable-path [str]
  "@param str string
@return boolean # `true` if path doesn't contain \".\" or \"..\" segments See `isreasonablepath.c`
@nodiscard"
  (_G.IsReasonablePath str))

(fn redbean.encode-url [url]
  "This function is the inverse of ParseUrl. The output will always be correctly
formatted. The exception is if illegal characters are supplied in the scheme
field, since there's no way of escaping those. Opaque parts are escaped as
though they were paths, since many URI parsers won't understand things like
an unescaped question mark in path.
@param url Url
@return string url
@nodiscard"
  (_G.EncodeUrl url))

(fn redbean.parse-ip [ip]
  "Converts IPv4 address string to integer, e.g. \"1.2.3.4\" → 0x01020304, or
returns -1 for invalid inputs. See also `FormatIp` for the inverse operation.
@param ip string
@return integer ip
@nodiscard"
  (_G.ParseIp ip))

(fn redbean.get-asset-comment [path]
  "@param path string
@return string? comment comment text associated with asset in the ZIP central directory.
@nodiscard"
  (_G.GetAssetComment path))

(fn redbean.get-comment [path]
  "@deprecated Use `GetAssetComment` instead.
@param path string
@return string?
@nodiscard"
  (_G.GetComment path))

(fn redbean.get-asset-last-modified-time [path]
  "@param path string
@return number seconds UNIX timestamp for modification time of a ZIP asset (or local file if the -D flag is used). If both a file and a ZIP asset are present, then the file is used.
@nodiscard"
  (_G.GetAssetLastModifiedTime path))

(fn redbean.get-last-modified-time [path]
  "@deprecated Use `GetAssetLastModifiedTime` instead.
@param path string
@return number
@nodiscard"
  (_G.GetLastModifiedTime path))

(fn redbean.get-asset-mode [path]
  "@param path string
@return integer mode UNIX-style octal mode for ZIP asset (or local file if the -D flag is used)
@nodiscard"
  (_G.GetAssetMode path))

(fn redbean.get-asset-size [path]
  "@param path string
@return integer bytesize byte size of uncompressed contents of ZIP asset (or local file if the `-D` flag is used)
@nodiscard"
  (_G.GetAssetSize path))

(fn redbean.get-body []
  "@return string body the request message body if present or an empty string.
@nodiscard"
  (_G.GetBody ))

(fn redbean.get-payload []
  "@return string
@nodiscard
@deprecated Use `GetBody` instead."
  (_G.GetPayload ))

(fn redbean.get-cookie [name]
  "@param name string
@return string cookie
@nodiscard"
  (_G.GetCookie name))

(fn redbean.md5 [str]
  "Computes MD5 checksum, returning 16 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Md5 str))

(fn redbean.sha1 [str]
  "Computes SHA1 checksum, returning 20 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Sha1 str))

(fn redbean.sha224 [str]
  "Computes SHA224 checksum, returning 28 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Sha224 str))

(fn redbean.sha256 [str]
  "Computes SHA256 checksum, returning 32 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Sha256 str))

(fn redbean.sha384 [str]
  "Computes SHA384 checksum, returning 48 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Sha384 str))

(fn redbean.sha512 [str]
  "Computes SHA512 checksum, returning 64 bytes of binary.
@param str string
@return string checksum
@nodiscard"
  (_G.Sha512 str))

(fn redbean.get-crypto-hash [name payload key]
  "@param name \"MD5\"|\"SHA1\"|\"SHA224\"|\"SHA256\"|\"SHA384\"|\"SHA512\"|\"BLAKE2B256\"
@param payload string
@param key string? If the key is provided, then HMAC value of the same function is returned.
@return string # value of the specified cryptographic hash function.
@nodiscard"
  (_G.GetCryptoHash name payload key))

(fn redbean.program-addr [ip]
  "Configures the address on which to listen. This can be called multiple times
to set more than one address. If an integer is provided then it should be a
word-encoded IPv4 address, such as the ones returned by `ResolveIp()`. If a
string is provided, it will first be passed to ParseIp() to see if it's an
IPv4 address. If it isn't, then a HOSTS.TXT lookup is performed, with fallback
to the system-configured DNS resolution service. Please note that in MODE=tiny
the HOSTS.TXT and DNS resolution isn't included, and therefore an IP must be
provided.
@param ip integer
@overload fun(host:string)"
  (_G.ProgramAddr ip))

(fn redbean.program-brand [str]
  "Changes HTTP Server header, as well as the `<h1>` title on the `/` listing page.
The brand string needs to be a UTF-8 value that's encodable as ISO-8859-1.
If the brand is changed to something other than redbean, then the promotional
links will be removed from the listing page too. This function should only be
called from `/.init.lua`.
@param str string"
  (_G.ProgramBrand str))

(fn redbean.program-cache [seconds directive]
  "Configures Cache-Control and Expires header generation for static asset serving.
A negative value will disable the headers. Zero means don't cache. Greater than
zero asks public proxies and browsers to cache for a given number of seconds.
The directive value is added to the Cache-Control header when specified (with
\"must-revalidate\" provided by default) and can be set to an empty  string to
remove the default value.
This should only be called from `/.init.lua`.
@param seconds integer
@param directive string?"
  (_G.ProgramCache seconds directive))

(fn redbean.program-certificate [pem]
  "This function is the same as the -C flag if called from `.init.lua`, e.g.
`ProgramCertificate(LoadAsset(\"/.sign.crt\"))` for zip loading or
`ProgramCertificate(Slurp(\"/etc/letsencrypt.lol/fullchain.pem\"))` for local
file system only. This function is not available in unsecure mode.
@param pem string"
  (_G.ProgramCertificate pem))

(fn redbean.program-header [name value]
  "Appends HTTP header to the header buffer for all responses (whereas `SetHeader`
only appends a header to the current response buffer). name is case-insensitive
and restricted to non-space ASCII. value is a UTF-8 string that must be
encodable as ISO-8859-1. Leading and trailing whitespace is trimmed
automatically. Overlong characters are canonicalized. C0 and C1 control codes
are forbidden, with the exception of tab. The header buffer is independent of
the payload buffer. This function disallows the setting of certain headers
such as Content-Range and Date, which are abstracted by the transport layer.
@param name string
@param value string"
  (_G.ProgramHeader name value))

(fn redbean.program-heartbeat-interval [milliseconds]
  "Sets the heartbeat interval (in milliseconds). 5000ms is the default and 100ms is the minimum.
@param milliseconds integer Negative values `(<0)` sets the interval in seconds."
  (_G.ProgramHeartbeatInterval milliseconds))

(fn redbean.program-timeout [milliseconds]
  "@param milliseconds integer Negative values `(<0)` sets the interval in seconds.
Default timeout is 60000ms. Minimal value of timeout is 10(ms).
This should only be called from `/.init.lua`."
  (_G.ProgramTimeout milliseconds))

(fn redbean.program-port [uint16]
  "Hard-codes the port number on which to listen, which can be any number in the
range `1..65535`, or alternatively `0` to ask the operating system to choose a
port, which may be revealed later on by `GetServerAddr` or the `-z` flag to stdout.
@param uint16 integer"
  (_G.ProgramPort uint16))

(fn redbean.program-max-payload-size [int]
  "Sets the maximum HTTP message payload size in bytes. The
default is very conservatively set to 65536 so this is
something many people will want to increase. This limit is
enforced at the transport layer, before any Lua code is
called, because right now redbean stores and forwards
messages. (Use the UNIX API for raw socket streaming.) Setting
this to a very high value can be useful if you're less
concerned about rogue clients and would rather have your Lua
code be granted more control to bounce unreasonable messages.
If a value less than 1450 is supplied, it'll automatically be
increased to 1450, since that's the size of ethernet frames.
This function can only be called from `.init.lua`.
@param int integer"
  (_G.ProgramMaxPayloadSize int))

(fn redbean.program-private-key [pem]
  "This function is the same as the -K flag if called from .init.lua, e.g.
`ProgramPrivateKey(LoadAsset(\"/.sign.key\"))` for zip loading or
`ProgramPrivateKey(Slurp(\"/etc/letsencrypt/privkey.pem\"))` for local file
system only. This function is not available in unsecure mode.
@param pem string"
  (_G.ProgramPrivateKey pem))

(fn redbean.program-redirect [code src location]
  "Configures fallback routing for paths which would otherwise return 404 Not
Found. If code is `0` then the path is rewritten internally as an accelerated
redirect. If code is `301`, `302`, `307`, or `308` then a redirect response
will be sent to the client. This should only be called from `/.init.lua`.
@param code integer
@param src string
@param location string"
  (_G.ProgramRedirect code src location))

(fn redbean.program-ssl-ticket-lifetime [seconds]
  "Defaults to `86400` (24 hours). This may be set to `≤0` to disable SSL tickets.
It's a good idea to use these since it increases handshake performance 10x and
eliminates a network round trip. This function is not available in unsecure mode.
@param seconds integer"
  (_G.ProgramSslTicketLifetime seconds))

(fn redbean.program-ssl-preshared-key [key identity]
  "This function can be used to enable the PSK ciphersuites which simplify SSL
and enhance its performance in controlled environments. key may contain 1..32
bytes of random binary data and identity is usually a short plaintext string.
The first time this function is called, the preshared key will be added to
both the client and the server SSL configs. If it's called multiple times,
then the remaining keys will be added to the server, which is useful if you
want to assign separate keys to each client, each of which needs a separate
identity too. If this function is called multiple times with the same identity
string, then the latter call will overwrite the prior. If a preshared key is
supplied and no certificates or key-signing-keys are programmed, then redbean
won't bother auto-generating any serving certificates and will instead use
only PSK ciphersuites. This function is not available in unsecure mode.
@param key string
@param identity string"
  (_G.ProgramSslPresharedKey key identity))

(fn redbean.program-ssl-fetch-verify [enabled]
  "May be used to disable the verification of certificates
for remote hosts when using the Fetch() API. This function is
not available in unsecure mode.
@param enabled boolean"
  (_G.ProgramSslFetchVerify enabled))

(fn redbean.program-ssl-client-verify [enabled]
  "Enables the verification of certificates supplied by the HTTP clients that
connect to your redbean. This has the same effect as the -j flag. Tuning this
option alone does not preclude the possibility of unsecured HTTP clients, which
can be disabled using ProgramSslRequired(). This function can only be called
from `.init.lua`. This function is not available in unsecure mode.
@param enabled boolean"
  (_G.ProgramSslClientVerify enabled))

(fn redbean.program-ssl-required [mandatory]
  "Enables the blocking of HTTP so that all inbound clients and must use the TLS
transport layer. This has the same effect as the -J flag. `Fetch()` is still
allowed to make outbound HTTP requests. This function can only be called from
`.init.lua`. This function is not available in unsecure mode.
@param mandatory string"
  (_G.ProgramSslRequired mandatory))

(fn redbean.program-ssl-ciphersuite [name]
  "This function may be called multiple times to specify the subset of available
ciphersuites you want to use in both the HTTPS server and the `Fetch()` client.
The default list, ordered by preference, is as follows:

- ECDHE-ECDSA-AES256-GCM-SHA384
- ECDHE-ECDSA-AES128-GCM-SHA256
- ECDHE-ECDSA-CHACHA20-POLY1305-SHA256
- ECDHE-PSK-AES256-GCM-SHA384
- ECDHE-PSK-AES128-GCM-SHA256
- ECDHE-PSK-CHACHA20-POLY1305-SHA256
- ECDHE-RSA-AES256-GCM-SHA384
- ECDHE-RSA-AES128-GCM-SHA256
- ECDHE-RSA-CHACHA20-POLY1305-SHA256
- DHE-RSA-AES256-GCM-SHA384
- DHE-RSA-AES128-GCM-SHA256
- DHE-RSA-CHACHA20-POLY1305-SHA256
- ECDHE-ECDSA-AES128-CBC-SHA256
- ECDHE-RSA-AES256-CBC-SHA384
- ECDHE-RSA-AES128-CBC-SHA256
- DHE-RSA-AES256-CBC-SHA256
- DHE-RSA-AES128-CBC-SHA256
- ECDHE-PSK-AES256-CBC-SHA384
- ECDHE-PSK-AES128-CBC-SHA256
- ECDHE-ECDSA-AES256-CBC-SHA
- ECDHE-ECDSA-AES128-CBC-SHA
- ECDHE-RSA-AES256-CBC-SHA
- ECDHE-RSA-AES128-CBC-SHA
- DHE-RSA-AES256-CBC-SHA
- DHE-RSA-AES128-CBC-SHA
- ECDHE-PSK-AES256-CBC-SHA
- ECDHE-PSK-AES128-CBC-SHA
- RSA-AES256-GCM-SHA384
- RSA-AES128-GCM-SHA256
- RSA-AES256-CBC-SHA256
- RSA-AES128-CBC-SHA256
- RSA-AES256-CBC-SHA
- RSA-AES128-CBC-SHA
- PSK-AES256-GCM-SHA384
- PSK-AES128-GCM-SHA256
- PSK-CHACHA20-POLY1305-SHA256
- PSK-AES256-CBC-SHA384
- PSK-AES128-CBC-SHA256
- PSK-AES256-CBC-SHA
- PSK-AES128-CBC-SHA
- ECDHE-RSA-3DES-EDE-CBC-SHA
- DHE-RSA-3DES-EDE-CBC-SHA
- ECDHE-PSK-3DES-EDE-CBC-SHA
- RSA-3DES-EDE-CBC-SHA
- PSK-3DES-EDE-CBC-SHA

When redbean is run on an old (or low-power) CPU that doesn't have the AES-NI
instruction set (Westmere c. 2010) then the default ciphersuite is tuned
automatically to favor the ChaCha20 Poly1305 suites.

The names above are canonical to redbean. They were programmatically simplified
from the official IANA names. This function will accept the IANA names too. In
most cases it will accept the OpenSSL and GnuTLS naming convention as well.

This function is not available in unsecure mode.
@param name string"
  (_G.ProgramSslCiphersuite name))

(fn redbean.is-daemon []
  "Returns `true` if `-d` flag was passed to redbean.
@return boolean
@nodiscard"
  (_G.IsDaemon ))

(fn redbean.program-uid [int]
  "Same as the `-U` flag if called from `.init.lua` for `setuid()`"
  (_G.ProgramUid int))

(fn redbean.program-gid [int]
  "Same as the `-G` flag if called from `.init.lua` for `setgid()`
@param int integer"
  (_G.ProgramGid int))

(fn redbean.program-directory [str]
  "Same as the `-D` flag if called from `.init.lua` for overlaying local file
system directories. This may be called multiple times. The first directory
programmed is preferred. These currently do not show up in the index page listing.
@param str string"
  (_G.ProgramDirectory str))

(fn redbean.program-log-messages [bool]
  "Same as the `-m` flag if called from `.init.lua` for logging message headers only.
@param bool boolean"
  (_G.ProgramLogMessages bool))

(fn redbean.program-log-bodies [bool]
  "Same as the `-b` flag if called from `.init.lua` for logging message bodies as
part of `POST` / `PUT` / etc. requests.
@param bool boolean"
  (_G.ProgramLogBodies bool))

(fn redbean.program-log-path [str]
  "Same as the `-L` flag if called from `.init.lua` for setting the log file path
on the local file system. It's created if it doesn't exist. This is called
before de-escalating the user / group id. The file is opened in append only
mode. If the disk runs out of space then redbean will truncate the log file if
has access to change the log file after daemonizing.
@param str string"
  (_G.ProgramLogPath str))

(fn redbean.program-pid-path [str]
  "Same as the `-P` flag if called from `.init.lua` for setting the pid file path
on the local file system. It's useful for reloading daemonized redbean using
`kill -HUP $(cat /var/run/redbean.pid)` or terminating redbean with
`kill $(cat /var/run/redbean.pid)` which will gracefully terminate all clients.
Sending the `TERM` signal twice will cause a forceful shutdown, which might
make someone with a slow internet connection who's downloading big files unhappy.
@param str string"
  (_G.ProgramPidPath str))

(fn redbean.program-uniprocess [bool]
  "Same as the `-u` flag if called from `.init.lua`. Can be used to configure the
uniprocess mode. The current value is returned.
@param bool boolean?
@return boolean"
  (_G.ProgramUniprocess bool))

(fn redbean.slurp [filename i j]
  "Reads all data from file the easy way.

This function reads file data from local file system. Zip file assets can be
accessed using the `/zip/...` prefix.

`i` and `j` may be used to slice a substring in filename. These parameters are
1-indexed and behave consistently with Lua's `string.sub()` API. For example:

    assert(Barf('x.txt', 'abc123'))
    assert(assert(Slurp('x.txt', 2, 3)) == 'bc')

This function is uninterruptible so `unix.EINTR` errors will be ignored. This
should only be a concern if you've installed signal handlers. Use the UNIX API
if you need to react to it.

@param filename string
@param i integer?
@param j integer?
@return string data
@nodiscard
@overload fun(filename: string, i?: integer, j?: integer): nil, unix.Errno"
  (_G.Slurp filename i j))

(fn redbean.barf [filename data mode flags offset]
  "Writes all data to file the easy way.

This function writes to the local file system.

@param filename string
@param data string
@param mode integer? defaults to 0644. This parameter is ignored when flags doesn't have `unix.O_CREAT`.

@param flags integer? defaults to `unix.O_TRUNC | unix.O_CREAT`.

@param offset integer? is 1-indexed and may be used to overwrite arbitrary slices within a file when used in conjunction with `flags=0`.
For example:

    assert(Barf('x.txt', 'abc123'))
    assert(Barf('x.txt', 'XX', 0, 0, 3))
    assert(assert(Slurp('x.txt', 1, 6)) == 'abXX23')

@return true
@overload fun(filename: string, data: string, mode?: integer, flags?: integer, offset?: integer): nil, error: unix.Errno"
  (_G.Barf filename data mode flags offset))

(fn redbean.sleep [seconds]
  "Sleeps the specified number of seconds (can be fractional).
The smallest interval is a microsecond.
@param seconds number"
  (_G.Sleep seconds))

(fn redbean.route [host path]
  "Instructs redbean to follow the normal HTTP serving path. This function is
useful when writing an OnHttpRequest handler, since that overrides the
serving path entirely. So if the handler decides it doesn't want to do
anything, it can simply call this function, to hand over control back to the
redbean core. By default, the host and path arguments are supplied from the
resolved `GetUrl` value. This handler always resolves, since it will generate
a 404 Not Found response if redbean couldn't find an appropriate endpoint.
@param host string?
@param path string?"
  (_G.Route host path))

(fn redbean.route-host [host path]
  "This is the same as `Route`, except it only implements the subset of request
routing needed for serving virtual-hosted assets, where redbean tries to prefix
the path with the hostname when looking up a file. This function returns `true`
if the request was resolved. If it was resolved, then your `OnHttpRequest`
request handler can still set additional headers.
@param host string?
@param path string?
@return boolean"
  (_G.RouteHost host path))

(fn redbean.route-path [path]
  "This is the same as `Route`, except it only implements the subset of request
routing needed for serving assets. This function returns `true` if the
request was resolved. If it was resolved, then your `OnHttpRequest` request
handler can still set additional headers.
@param path string?
@return boolean"
  (_G.RoutePath path))

(fn redbean.serve-asset [path]
  "Instructs redbean to serve static asset at path. This function causes what
 would normally happen outside a dynamic handler to happen. The asset can be
sourced from either the zip or local filesystem if `-D` is used. This function
is mutually exclusive with `SetStatus` and `ServeError`.
@param path string"
  (_G.ServeAsset path))

(fn redbean.serve-error [code reason]
  "Instructs redbean to serve a boilerplate error page. This takes care of logging
the error, setting the reason phrase, and adding a payload. This function is
mutually exclusive with `SetStatus` and `ServeAsset`.
@param code integer
@param reason string?"
  (_G.ServeError code reason))

(fn redbean.serve-redirect [code location]
  "Instructs redbean to return the specified redirect code along with
the Location header set. This function is mutually exclusive with
`SetStatus` and other `Serve*` functions.

@param code integer
@param location string"
  (_G.ServeRedirect code location))

(fn redbean.set-log-level [level]
  "Sets logger verbosity. Reasonable values for level are `kLogDebug` >
`kLogVerbose` > `kLogInfo` > `kLogWarn` > `kLogError` > `kLogFatal`.
@param level integer"
  (_G.SetLogLevel level))

(fn redbean.visualize-control-codes [str]
  "Replaces C0 control codes and trojan source characters with descriptive
UNICODE pictorial representation. This function also canonicalizes overlong
encodings. C1 control codes are replaced with a JavaScript-like escape sequence.
@param str string
@return string
@nodiscard"
  (_G.VisualizeControlCodes str))

(fn redbean.underlong [str]
  "Canonicalizes overlong encodings.
@param str string
@return string
@nodiscard"
  (_G.Underlong str))

(fn redbean.uuid-v4 []
  "Generate a uuid_v4
@return string"
  (_G.UuidV4 ))

(fn redbean.uuid-v7 []
  "Generate a uuid_v7
@return string"
  (_G.UuidV7 ))

(fn redbean.bsf [x]
  "@param x integer
@return integer # position of first bit set.
Passing `0` will raise an error. Same as the Intel x86 instruction BSF.
@nodiscard"
  (_G.Bsf x))

(fn redbean.bsr [x]
  "@param x integer
@return integer # binary logarithm of `x`
Passing `0` will raise an error. Same as the Intel x86 instruction BSR.
@nodiscard"
  (_G.Bsr x))

(fn redbean.crc32 [initial data]
  "Computes Phil Katz CRC-32 used by zip/zlib/gzip/etc.
@param initial integer
@param data string
@return integer
@nodiscard"
  (_G.Crc32 initial data))

(fn redbean.crc32c [initial data]
  "Computes 32-bit Castagnoli Cyclic Redundancy Check.
@param initial integer
@param data string
@return integer
@nodiscard"
  (_G.Crc32c initial data))

(fn redbean.popcnt [x]
  "Returns number of bits set in integer.
@param x integer
@return integer
@nodiscard"
  (_G.Popcnt x))

(fn redbean.rdtsc []
  "Returns CPU timestamp counter.
@return integer
@nodiscard"
  (_G.Rdtsc ))

(fn redbean.lemur64 []
  "@return integer # fastest pseudorandom non-cryptographic random number.
This linear congruential generator passes practrand and bigcrush.
@nodiscard"
  (_G.Lemur64 ))

(fn redbean.rand64 []
  "@return integer # nondeterministic pseudorandom non-cryptographic number.
This linear congruential generator passes practrand and bigcrush. This
generator is safe across `fork()`, threads, and signal handlers.
@nodiscard"
  (_G.Rand64 ))

(fn redbean.rdrand []
  "@return integer # 64-bit hardware random integer from RDRND instruction, with automatic fallback to `getrandom()` if not available.
@nodiscard"
  (_G.Rdrand ))

(fn redbean.rdseed []
  "@return integer # 64-bit hardware random integer from `RDSEED` instruction, with automatic fallback to `RDRND` and `getrandom()` if not available.
@nodiscard"
  (_G.Rdseed ))

(fn redbean.get-cpu-count []
  "@return integer cpucount CPU core count or `0` if it couldn't be determined.
@nodiscard"
  (_G.GetCpuCount ))

(fn redbean.get-cpu-core []
  "@return integer # 0-indexed CPU core on which process is currently scheduled.
@nodiscard"
  (_G.GetCpuCore ))

(fn redbean.get-cpu-node []
  "@return integer # 0-indexed NUMA node on which process is currently scheduled.
@nodiscard"
  (_G.GetCpuNode ))

(fn redbean.decimate [data]
  "Shrinks byte buffer in half using John Costella's magic kernel. This downscales
data 2x using an eight-tap convolution, e.g.

    >: Decimate('\\xff\\xff\\x00\\x00\\xff\\xff\\x00\\x00\\xff\\xff\\x00\\x00')
    \"\\xff\\x00\\xff\\x00\\xff\\x00\"

This is very fast if SSSE3 is available (Intel 2004+ / AMD 2011+).
@param data string
@return string
@nodiscard"
  (_G.Decimate data))

(fn redbean.measure-entropy [data]
  "@param data string
@return number # Shannon entropy of `data`.
This gives you an idea of the density of information. Cryptographic random
should be in the ballpark of `7.9` whereas plaintext will be more like `4.5`.
@nodiscard"
  (_G.MeasureEntropy data))

(fn redbean.deflate [uncompressed level]
  "Compresses data.

    >: Deflate(\"hello\")
    \"\\xcbH\\xcd\\xc9\\xc9\\x07\\x00\"
    >: Inflate(\"\\xcbH\\xcd\\xc9\\xc9\\x07\\x00\", 5)
    \"hello\"

The output format is raw DEFLATE that's suitable for embedding into formats
like a ZIP file. It's recommended that, like ZIP, you also store separately a
`Crc32()` checksum in addition to the original uncompressed size.

@param uncompressed string
@param level integer? the compression level, which defaults to `7`. The max is `9`.
Lower numbers go faster (4 for instance is a sweet spot) and higher numbers go
slower but have better compression.
@return string compressed
@nodiscard
@overload fun(uncompressed: string, level?: integer): nil, error: string"
  (_G.Deflate uncompressed level))

(fn redbean.inflate [compressed maxoutsize]
  "Decompresses data.

This function performs the inverse of Deflate(). It's recommended that you
perform a `Crc32()` check on the output string after this function succeeds.

@param compressed string
@param maxoutsize integer the uncompressed size, which should be known.
However, it is permissable (although not advised) to specify some large number
in which case (on success) the byte length of the output string may be less
than `maxoutsize`.
@return string uncompressed
@nodiscard
@overload fun(compressed: string, maxoutsize: integer): nil, error: string"
  (_G.Inflate compressed maxoutsize))

(fn redbean.benchmark [func count maxattempts]
  "Performs microbenchmark. Nanoseconds are computed from RDTSC tick counts,
using an approximation that's measured beforehand with the
unix.`clock_gettime()` function. The `ticks` result is the canonical average
number of clock ticks. This subroutine will subtract whatever the overhead
happens to be for benchmarking a function that does nothing. This overhead
value will be reported in the result. `tries` indicates if your microbenchmark
needed to be repeated, possibly because your system is under load and the
benchmark was preempted by the operating system, or moved to a different core.
@param func function
@param count integer?
@param maxattempts integer?
@return number nanoseconds the average number of nanoseconds that `func` needed to execute
@return integer ticks
@return integer overhead_ticks
@return integer tries
@nodiscard"
  (_G.Benchmark func count maxattempts))

(fn redbean.oct [int]
  "Formats string as octal integer literal string. If the provided value is zero,
the result will be `\"0\"`. Otherwise the resulting value will be the
zero-prefixed octal string. The result is currently modulo 2^64. Negative
numbers are converted to unsigned.
@param int integer
@return string
@nodiscard"
  (_G.oct int))

(fn redbean.hex [int]
  "Formats string as hexadecimal integer literal string. If the provided value is
zero, the result will be `\"0\"`. Otherwise the resulting value will be the
\"0x\"-prefixed hex string. The result is currently modulo 2^64. Negative numbers
are converted to unsigned.
@param int integer
@return string
@nodiscard"
  (_G.hex int))

(fn redbean.bin [int]
  "Formats string as binary integer literal string. If the provided value is zero,
the result will be `\"0\"`. Otherwise the resulting value will be the
\"0b\"-prefixed binary str. The result is currently modulo 2^64. Negative numbers
are converted to unsigned.
@param int integer
@return string
@nodiscard"
  (_G.bin int))

(fn redbean.resolve-ip [hostname]
  "Gets IP address associated with hostname.

This function first checks if hostname is already an IP address, in which case
it returns the result of `ParseIp`. Otherwise, it checks HOSTS.TXT on the local
system and returns the first IPv4 address associated with hostname. If no such
entry is found, a DNS lookup is performed using the system configured (e.g.
`/etc/resolv.conf`) DNS resolution service. If the service returns multiple IN
A records then only the first one is returned.

The returned address is word-encoded in host endian order. For example,
1.2.3.4 is encoded as 0x01020304. The `FormatIp` function may be used to turn
this value back into a string.

If no IP address could be found, then `nil` is returned alongside a string of
unspecified format describing the error. Calls to this function may be wrapped
in `assert()` if an exception is desired.
@param hostname string
@return uint32 ip uint32
@nodiscard
@overload fun(hostname: string): nil, error: string"
  (_G.ResolveIp hostname))

(fn redbean.is-trusted-ip [ip]
  "Returns `true` if IP address is trustworthy.
If the `ProgramTrustedIp()` function has NOT been called then redbean
will consider the networks 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12,
and 192.168.0.0/16 to be trustworthy too. If `ProgramTrustedIp()` HAS
been called at some point earlier in your redbean's lifecycle, then
it'll trust the IPs and network subnets you specify instead.
The network interface addresses used by the host machine are always
considered trustworthy, e.g. 127.0.0.1. This may change soon, if we
decide to export a `GetHostIps()` API which queries your NIC devices.
@param ip integer
@return boolean"
  (_G.IsTrustedIp ip))

(fn redbean.program-trusted-ip [ip cidr]
  "Trusts an IP address or network
This function may be used to configure the `IsTrustedIp()` function
which is how redbean determines if a client is allowed to send us
headers like X-Forwarded-For (cf `GetRemoteAddr` vs. `GetClientAddr`)
without them being ignored. Trusted IPs is also how redbean turns
off token bucket rate limiting selectively, so be careful. Here's
an example of how you could trust all of Cloudflare's IPs:

    ProgramTrustedIp(ParseIp(\"103.21.244.0\"), 22);
    ProgramTrustedIp(ParseIp(\"103.22.200.0\"), 22);
    ProgramTrustedIp(ParseIp(\"103.31.4.0\"), 22);
    ProgramTrustedIp(ParseIp(\"104.16.0.0\"), 13);
    ProgramTrustedIp(ParseIp(\"104.24.0.0\"), 14);
    ProgramTrustedIp(ParseIp(\"108.162.192.0\"), 18);
    ProgramTrustedIp(ParseIp(\"131.0.72.0\"), 22);
    ProgramTrustedIp(ParseIp(\"141.101.64.0\"), 18);
    ProgramTrustedIp(ParseIp(\"162.158.0.0\"), 15);
    ProgramTrustedIp(ParseIp(\"172.64.0.0\"), 13);
    ProgramTrustedIp(ParseIp(\"173.245.48.0\"), 20);
    ProgramTrustedIp(ParseIp(\"188.114.96.0\"), 20);
    ProgramTrustedIp(ParseIp(\"190.93.240.0\"), 20);
    ProgramTrustedIp(ParseIp(\"197.234.240.0\"), 22);
    ProgramTrustedIp(ParseIp(\"198.41.128.0\"), 17);

Although you might want consider trusting redbean's open source
freedom embracing solution to DDOS protection instead!
@param ip integer
@param cidr integer?"
  (_G.ProgramTrustedIp ip cidr))

(fn redbean.program-token-bucket [replenish cidr reject ignore ban]
  "Enables DDOS protection.

Imagine you have 2**32 buckets, one for each IP address. Each bucket
can hold about 127 tokens. Every second a background worker puts one
token in each bucket. When a TCP client socket is opened, it takes a
token from its bucket, and then proceeds. If the bucket holds only a
third of its original tokens, then redbean sends them a 429 warning.
If the client ignores this warning and keeps sending requests, until
there's no tokens left, then the banhammer finally comes down.

   function OnServerStart()
       ProgramTokenBucket()
       ProgramTrustedIp(ParseIp('x.x.x.x'), 32)
       assert(unix.setrlimit(unix.RLIMIT_NPROC, 1000, 1000))
   end

This model of network rate limiting generously lets people \"burst\" a
tiny bit. For example someone might get a strong craving for content
and smash the reload button in Chrome 64 times in a fow seconds. But
since the client only get 1 new token per second, they'd better cool
their heels for a few minutes after doing that. This amount of burst
can be altered by choosing the `reject` / `ignore` / `ban` threshold
arguments. For example, if the `reject` parameter is set to 126 then
no bursting is allowed, which probably isn't a good idea.

redbean is programmed to acquire a token immediately after accept()
is called from the main server process, which is well before fork()
or read() or any Lua code happens. redbean then takes action, based
on the token count, which can be accept / reject / ignore / ban. If
redbean determines a ban is warrented, then 4-byte datagram is sent
to the unix domain socket `/var/run/blackhole.sock` which should be
operated using the blackholed program we distribute separately.

The trick redbean uses on Linux for example is insert rules in your
raw prerouting table. redbean is very fast at the application layer
so the biggest issue we've encountered in production is are kernels
themselves, and programming the raw prerouting table dynamically is
how we solved that.

`replenish` is the number of times per second a token should be
added to each bucket. The default value is 1 which means one token
is granted per second to all buckets. The minimum value is 1/3600
which means once per hour. The maximum value for this setting is
1e6, which means once every microsecond.

`cidr` is the specificity of judgement.  Since creating 2^32 buckets
would need 4GB of RAM, redbean defaults this value to 24 which means
filtering applies to class c network blocks (i.e. x.x.x.*), and your
token buckets only take up 2^24 bytes of RAM (16MB). This can be set
to any number on the inclusive interval [8,32], where having a lower
number means you use less ram/cpu, but splash damage applies more to
your clients; whereas higher numbers means more ram/cpu usage, while
ensuring rate limiting only applies to specific compromised actors.

`reject` is the token count or treshold at which redbean should send
429 Too Many Request warnings to the client. Permitted values can be
anywhere between -1 and 126 inclusively. The default value is 30 and
-1 means disable to disable (assuming AcquireToken() will be used).

`ignore` is the token count or treshold, at which redbean should try
simply ignoring clients and close the connection without logging any
kind of warning, and without sending any response. The default value
for this setting is `MIN(reject / 2, 15)`. This must be less than or
equal to the `reject` setting. Allowed values are [-1,126] where you
can use -1 as a means of disabling `ignore`.

`ban` is the token count at which redbean should report IP addresses
to the blackhole daemon via a unix-domain socket datagram so they'll
get banned in the kernel routing tables. redbean's default value for
this setting is `MIN(ignore / 10, 1)`. Permitted values are [-1,126]
where -1 may be used as a means of disabling the `ban` feature.

This function throws an exception if the constraints described above
are not the case. Warnings are logged should redbean fail to connect
to the blackhole daemon, assuming it hasn't been disabled. It's safe
to use load balancing tools when banning is enabled, since you can't
accidentally ban your own network interface addresses, loopback ips,
or ProgramTrustedIp() addresses where these rate limits don't apply.

It's assumed will be called from the .init.lua global scope although
it could be used in interpreter mode, or from a forked child process
in which case the only processes that'll have ability to use it will
be that same process, and any descendent processes. This function is
only able to be called once.

This feature is not available in unsecure mode.
@param replenish number?
@param cidr integer?
@param reject integer?
@param ignore integer?
@param ban integer?"
  (_G.ProgramTokenBucket replenish cidr reject ignore ban))

(fn redbean.acquire-token [ip]
  "Atomically acquires token.

This routine atomically acquires a single token for an `ip` address.
The return value is the token count before the subtraction happened.
No action is taken based on the count, since the caller will decide.

`ip` should be an IPv4 address and this defaults to `GetClientAddr()`,
although other interpretations of its meaning are possible.

Your token buckets are stored in shared memory so this can be called
from multiple forked processes. which operate on the same values.
@param ip uint32?
@return int8"
  (_G.AcquireToken ip))

(fn redbean.count-tokens [ip]
  "Counts number of tokens in bucket.

This function is the same as AcquireToken() except no subtraction is
performed, i.e. no token is taken.

`ip` should be an IPv4 address and this defaults to GetClientAddr(),
although other interpretations of its meaning are possible.
@param ip uint32?
@return int8"
  (_G.CountTokens ip))

redbean