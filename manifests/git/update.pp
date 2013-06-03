define nby::git::update($repo, $place, $branch='master') {

  exec {"git_clone_$title":
    path        => "/usr/local/bin:/usr/bin",
    cwd         => $place,
    command     => "git clone $repo -b $branch $place",
    onlyif      => "/bin/test ! -d $place/.git",
  }

  exec {"git_update_$title":
    path        => "/usr/local/bin:/usr/bin",
    cwd         => $place,
    command     => "git pull -u origin $branch",
  }

}
