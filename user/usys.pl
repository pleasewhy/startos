#!/usr/bin/perl -w

print "# generated by usys.pl - do not edit\n";

print "#include \"os/SyscallNum.hpp\"\n";

sub entry {
    my $name = shift;
    print ".global $name\n";
    print "${name}:\n";
    print " li a7, SYS_${name}\n";
    print " ecall\n";
    print " ret\n";
}

entry("fork");
entry("wait");
entry("open");
entry("getcwd");
entry("dup");
entry("dup3");
entry("mkdirat");
entry("unlinkat");
entry("linkat");
entry("umount2");
entry("mount");
entry("chdir");
entry("close");
entry("pipe2");
entry("getdents64");
entry("read");
entry("write");
entry("fstat");
entry("exit");
entry("nanosleep");
entry("sched_yield");
entry("times");
entry("uname");
entry("gettimeofday");
entry("brk");
entry("munmap");
entry("getpid");
entry("getppid");
entry("clone");
entry("execve");
entry("mmap");
entry("wait4");



