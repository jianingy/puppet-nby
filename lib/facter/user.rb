Facter.add('home') do
  setcode do
    ENV['HOME']
  end
end

Facter.add('gid') do
  setcode do
    ENV['GID']
  end
end
