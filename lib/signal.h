#ifndef STARTOS_SIGAL_H
#define STARTOS_SIGAL_H
union __sigval
{
  int   __sival_int;
  void *__sival_ptr;
};

typedef union __sigval __sigval_t;

typedef unsigned long int __sigset_t;
typedef __sigset_t        sigset_t;

typedef struct
{
  int si_signo;         /* Signal number.  */
  int si_errno;         /* If non-zero, an errno value associated with
                   this signal, as defined in <errno.h>.  */
  int        si_code;   /* Signal code.  */
  int        si_pid;    /* Sending process ID.  */
  int        si_uid;    /* Real user ID of sending process.  */
  void *     si_addr;   /* Address of faulting instruction.  */
  int        si_status; /* Exit value or signal.  */
  long int   si_band;   /* Band event for SIGPOLL.  */
  __sigval_t si_value;  /* Signal value.  */
} siginfo_t;

typedef void (*__sighandler_t) (int);

struct sigaction
{
  /* Signal handler.  */
  __sighandler_t sa_handler;

  /* Additional set of signals to be blocked.  */
  __sigset_t sa_mask;

  /* Special flags.  */
  int sa_flags;
  void     (*sa_restorer)(void);
};

/*
 * SA_FLAGS values:
 *
 * SA_ONSTACK indicates that a registered stack_t will be used.
 * SA_RESTART flag to get restarting signals (which were the default long ago)
 * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
 * SA_RESETHAND clears the handler when the signal is delivered.
 * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
 * SA_NODEFER prevents the current signal from being masked in the handler.
 *
 * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
 * Unix names RESETHAND and NODEFER respectively.
 */

#define SA_ONSTACK	0x00000001
#define SA_RESTART	0x00000002
#define SA_NOCLDSTOP	0x00000004
#define SA_NODEFER	0x00000008
#define SA_RESETHAND	0x00000010
#define SA_NOCLDWAIT	0x00000020
#define SA_SIGINFO	0x00000040

#define SIGRTMIN	32l
#endif