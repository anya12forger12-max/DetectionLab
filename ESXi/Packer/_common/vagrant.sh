#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";
# Pinned hash of the well-known Vagrant insecure public key. Certificate
# validation alone is not enough when this key is baked into base images:
# a poisoned build would grant permanent SSH access to every derived VM.
expected_sha256="9aa9292172c915821e29bcbf5ff42d4940f59d6a148153c76ad638f5f4c6cd8b";
authorized_keys="$HOME_DIR"/.ssh/authorized_keys;
mkdir -p "$HOME_DIR"/.ssh;
if command -v wget >/dev/null 2>&1; then
    wget "$pubkey_url" -O "$authorized_keys";
elif command -v curl >/dev/null 2>&1; then
    curl --fail --location "$pubkey_url" -o "$authorized_keys";
elif command -v fetch >/dev/null 2>&1; then
    fetch -am -o "$authorized_keys" "$pubkey_url";
else
    echo "Cannot download vagrant public key";
    exit 1;
fi
if command -v sha256sum >/dev/null 2>&1; then
    actual_sha256=$(sha256sum "$authorized_keys" | awk '{print $1}');
elif command -v shasum >/dev/null 2>&1; then
    actual_sha256=$(shasum -a 256 "$authorized_keys" | awk '{print $1}');
else
    echo "Cannot verify vagrant public key: no SHA-256 utility available";
    exit 1;
fi
if [ "$actual_sha256" != "$expected_sha256" ]; then
    echo "Vagrant public key hash mismatch; refusing to bake it into the image";
    exit 1;
fi
chown -R vagrant "$HOME_DIR"/.ssh;
chmod -R go-rwsx "$HOME_DIR"/.ssh;
