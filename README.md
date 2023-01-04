# why?
There are so many wireguard mesh network creators out there, they'll create nodes for you, connect them over some weird protocols that are authenticated and keep it all in sync for you but they're very limiting for me.

I like keeping my nodes identifiable based on public keys with [warner/wireguard-vanity-address](https://github.com/warner/wireguard-vanity-address) and a lot of those generators automatically generate a keypair for you - for security, I guess. I wish I could just use one and it would accept my vanity keys but they usually do not.

Most of the packages requires Ubuntu or Debian which is not helpful when I'm on a mix of Alpine, Arch, Debian across wireguard-dkms, wireguard-go, boringtun and native kernel wireguard.

I also don't like keeping my private keys out in the open. I generate them when I spin up a node and if I rotate one out, then I generate a new one.

I used to roll it manually by generating a master config and populating all the other machines but it became a hassle across rotating nodes, removing a node in the middle or trying to 

There's also the problem of not being able to have one master config for all the wireguard nodes. A node can have it's own address listed in the peers, that's not an issue but some nodes use different interfaces for IPTables forwarding. (vnet0 vs eno1 vs eth0 etc...)

Enter: this stupid script

Because it does nothing more than concat two files together, it's compatible with everything! I use my own [wg-config-mustache](https://github.com/mchangrh/wg-config-mustache) to mass generate client configs but you can even roll it by hand if you want.

# how?

1. Create a file with all the public keys and endpoints of all your nodes (`mesh.conf`)
    1. Yes this probably comprimises some security somewhere but you can deal with that how you wish
    2. Host it somewhere (I use a private git + caddy repo but anything works.)
2. Create a `/etc/wireguard/head.conf` file for each machine with anything in the `[Interface]` block
3. run `update.sh` (or run it from curl)
    1. `update.sh` updates itself 
    2. Downloads `mesh.conf`
    3. cat them together into `wg0.conf`
    4. restarts wireguard

Whenever I add a new host, client or rotate one out, I just run `/etc/wireguard/update.sh` and call it a day.

# mesh.conf
mesh.conf contains all the PublicKeys, AllowedIPs and Endpoints of mesh nodes and also the client list. Update this on the server you pull from and it'll make it's way down to your devices.

# openRC wg-quick
I use openRC (alpine linux) on some of my machines for better wireguard-go support and I use the gentoo init.d script. Script licenced GPLv2

# copy me
If you want to copy my format:
My hostnames are based off of {ISO-3166}-{LOCODE}.{provider}.domain.tld

a Hetzner machine hosted in Ashburn, Virginia, US would be
`us-ash.htz.domain.tld`

[UN/LOCODE](https://unece.org/trade/cefact/unlocode-code-list-country-and-territory)  
[ISO-3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)  
provider is an abbreviation of the VPS provider
```
digitalocean -> do
hetzner -> htz
Google Cloud -> gcp
AWS -> aws
OVH -> ovh
BuyVM -> bvm
Virmach - vms
```