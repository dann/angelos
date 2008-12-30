#!/bin/sh
rm -f lib/Angelos/Script/Generate/Flavor/App.pm
module-setup --pack Angelos::Script::Command::Generate::Flavor::App angelos-app > lib/Angelos/Script/Command/Generate/Flavor/App.pm
