define nby::git::update($repo, $place, $branch='master') {

  exec {"git_clone_$title":
    path        => "/usr/local/bin:/usr/bin:/bin",
    cwd         => $place,
    command     => "git clone $repo -b $branch $place",
    onlyif      => "test ! -d $place/.git",
  }

  exec {"git_update_$title":
    path        => "/usr/local/bin:/usr/bin:/bin",
    cwd         => $place,
    command     => "git pull -v -u origin $branch",
  } ->
  exec {"git_submodule_init_$title":
    path        => "/usr/local/bin:/usr/bin:/bin",
    cwd         => $place,
    command     => "git submodule init",
  } ->
  exec {"git_submodule_update_$title":
    path        => "/usr/local/bin:/usr/bin:/bin",
    cwd         => $place,
    command     => "git submodule update",
  }

}
