#ifndef _StartOS_PATH_HPP
#define _StartOS_PATH_HPP

struct dentry;
// struct vfsmount;

struct path
{
  // struct vfsmount *mnt;
  struct dentry *dentry;
};
#endif /* _StartOS_PATH_HPP */