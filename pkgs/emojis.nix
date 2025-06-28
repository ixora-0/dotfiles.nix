# download emojis
# commands from https://github.com/Zeioth/wofi-emoji
{ fetchurl, runCommand, jq }: let
  raw-emojis = fetchurl {
    url = "https://raw.githubusercontent.com/muan/emojilib/v4.0.1/dist/emoji-en-US.json";
    hash = "sha256-HDeA/0WOaiNMTalC54U5uhTFZErEe3SOaDEstU8I32E=";
  };
in runCommand "emojilib-emojis" {} ''
  echo "### DATA ###" > $out
  ${jq}/bin/jq --raw-output '. | to_entries | .[] | .key + " " + (.value | join(" ") | sub("_"; " "; "g"))' ${raw-emojis} >> $out
''
