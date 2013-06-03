define nby::ssh::public_key($keyname, $key) {
  concat::fragment{"authorized_keys_$title":
    target  => 'authorized_keys',
    content => "$key $keyname\n",
  }
}
