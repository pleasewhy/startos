#ifndef _POLL_HPP
#define _POLL_HPP
/* Data structure describing a polling request.  */
struct pollfd
{
  int       fd;      /* File descriptor to poll.  */
  short int events;  /* Types of events poller cares about.  */
  short int revents; /* Types of events that actually occurred.  */
};

/* Event types that can be polled for.  These bits may be set in `events'
   to indicate the interesting event types; they will appear in `revents'
   to indicate the status of the file descriptor.  */
#define POLLIN 01  /* There is data to read.  */
#define POLLPRI 02 /* There is urgent data to read.  */
#define POLLOUT 04 /* Writing now will not block.  */
#endif