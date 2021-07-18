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
#endif