{
  # Short status
  st = "status";

  # Logging
  lg = "log --oneline --graph --decorate";

  # Add all and amend without editing the commit message
  aacan = "!git add --all && git commit --amend --no-edit";

  # Add all and commit with a message
  aacm = "!git add --all && git commit -m";

  # Show the last commit with stats
  last = "log -1 HEAD --stat";

  # Short checkout
  co = "checkout";

  # Short checkout and create a new branch
  cob = "checkout -b";

  # Short switch and create a new branch
  swc = "switch -c";

  # Short switch
  sw = "switch";

  # Short branch
  br = "branch";
}
