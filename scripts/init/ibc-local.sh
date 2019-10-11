git clone git@github.com:cosmos/gaia
cd gaia
git checkout joon/ibc-gaia-interface
export GO111MODULE=on
go mod vendor
make install
gaiad version
gaiacli version
cd ~ && mkdir ibc-testnets && cd ibc-testnets
gaiad testnet -o ibc0 --v 1 --chain-id ibc0 --node-dir-prefix n
gaiad testnet -o ibc1 --v 1 --chain-id ibc1 --node-dir-prefix n
if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Sed done for osx"
  sed -i '' 's/"leveldb"/"goleveldb"/g' ibc0/n0/gaiad/config/config.toml
sed -i '' 's/"leveldb"/"goleveldb"/g' ibc1/n0/gaiad/config/config.toml
sed -i '' 's#"tcp://0.0.0.0:26656"#"tcp://0.0.0.0:26556"#g' ibc1/n0/gaiad/config/config.toml
sed -i '' 's#"tcp://0.0.0.0:26657"#"tcp://0.0.0.0:26557"#g' ibc1/n0/gaiad/config/config.toml
sed -i '' 's#"localhost:6060"#"localhost:6061"#g' ibc1/n0/gaiad/config/config.toml
sed -i '' 's#"tcp://127.0.0.1:26658"#"tcp://127.0.0.1:26558"#g' ibc1/n0/gaiad/config/config.toml
else
        echo "sed done for ubuntu"
  sed -i 's/"leveldb"/"goleveldb"/g' ibc0/n0/gaiad/config/config.toml
sed -i 's/"leveldb"/"goleveldb"/g' ibc1/n0/gaiad/config/config.toml
sed -i 's#"tcp://0.0.0.0:26656"#"tcp://0.0.0.0:26556"#g' ibc1/n0/gaiad/config/config.toml
sed -i 's#"tcp://0.0.0.0:26657"#"tcp://0.0.0.0:26557"#g' ibc1/n0/gaiad/config/config.toml
sed -i 's#"localhost:6060"#"localhost:6061"#g' ibc1/n0/gaiad/config/config.toml
sed -i 's#"tcp://127.0.0.1:26658"#"tcp://127.0.0.1:26558"#g' ibc1/n0/gaiad/config/config.toml
fi

gaiacli config --home ibc0/n0/gaiacli/ chain-id ibc0
gaiacli config --home ibc1/n0/gaiacli/ chain-id ibc1
gaiacli config --home ibc0/n0/gaiacli/ node http://localhost:26657
gaiacli config --home ibc1/n0/gaiacli/ node http://localhost:26557

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "this is osx"
  brew install jq
  jq -r '.secret' ibc1/n0/gaiacli/key_seed.json | pbcopy
else
  echo "this is ubuntu"
  sudo apt install xclip -y
  sudo apt install jq
  jq -r '.secret' ibc1/n0/gaiacli/key_seed.json | xclip -sel clip
  gaiacli --home ibc0/n0/gaiacli keys add n1 --recover

fi

# Paste the mnemonic from the above command after setting password (12345678)
gaiacli --home ibc0/n0/gaiacli keys add n1 --recover

echo "setup done,start two nodes now"
