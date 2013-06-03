class nby::vim {
  # pull emacs configuration from github
  file {"$home/.vim":
    ensure   => directory,
    mode     => '0755',
    force    => true,
  } ->
  nby::git::update {'vim':
    repo     => 'git@github.com:jianingy/vimrc',
    branch   => 'master',
    place    => "$home/.vim",
  } ->
  file {"$home/.vimrc":
    ensure   => link,
    target   => '.vim/vimrc',
    mode     => '0644',
  }
}
