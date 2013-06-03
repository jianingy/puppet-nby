class nby::zsh {
  # pull zsh configuration from github
  file {"$home/.zsh":
    ensure   => directory,
    mode     => '0755',
    force    => true,
  } ->
  nby::git::update {'zsh':
    repo     => 'git@github.com:jianingy/zsh-trip',
    branch   => 'master',
    place    => "$home/.zsh",
  } ->
  file {"$home/.zshrc":
    ensure   => link,
    target   => '.zsh/zshrc',
    mode     => '0644',
  }
}
