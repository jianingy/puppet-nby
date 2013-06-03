define nby::gpg::public_key {
  exec {"gpg_$title":
    path    => "/usr/local/bin:/usr/bin",
    command => "gpg --recv-keys $title",
  }
}
