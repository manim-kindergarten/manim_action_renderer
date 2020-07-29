#!/bin/bash

set -e

info() {
  echo -e "\033[1;34m$1\033[0m"
}

warn() {
  echo "::warning :: $1"
}

error() {
  echo "::error :: $1"
  exit 1
}

source_file="${1}"
scene_names="${2}"
args="${3}"
manim_repo="${4}"
extra_packages="${5}"
extra_system_packages="${6}"
pre_render="${7}"
post_render="${8}"
merge_assets="${9}"
fonts_dir="${10}"
extra_repos="${11}"
community="${12}"

if [[ "$manim_repo" == "https://github.com/ManimCommunity/manim" || "$manim_repo" == "https://github.com/ManimCommunity/manim/" ]]; then
  community=true
fi
echo "Community? $community"

if [[ -z "$source_file" ]]; then
  error "Input 'source_file' is missing."
fi

if [[ -n $fonts_dir ]]; then
  info "Adding fonts..."
  cp -r "$fonts_dir" /usr/share/fonts/custom
  ls /usr/share/fonts/custom
  apt install fontconfig -y
  mkfontscale
  mkfontdir
  fc-cache -fv
fi

info "Cloning $manim_repo ..."
if [[ $community == true ]]; then
  git clone "$manim_repo" manimcm --depth=1
else
  git clone "$manim_repo" manim --depth=1
fi

merge() {
  if [[ -e $1 && -e $2 ]]; then
    for i in $(ls $2); do
      if [[ -e "$1$i" ]]; then
        if [[ -d "$1$i" ]]; then
          merge "$1$i/" "$2$i/"
        fi
      else
        mv "$2$i" "$1$i"
      fi
    done
    rm -rf "$2"
  fi
}

if [[ $merge_assets == true && $community == false ]]; then
  merge "assets/" "manim/assets/"
fi

if [[ $community == true ]]; then
  mv manimcm/* .
else
  mv manim/* .
fi

info "Installing requirements of manim..."
if [[ community == true ]]; then
  python -m pip install -e .
else
  python -m pip install -r requirements.txt
fi

if [[ -n "$extra_system_packages" ]]; then
  for pkg in $extra_system_packages; do
    info "Installing $pkg by apk..."
    apk --no-cache add "$pkg"
  done
fi

if [[ -n "$extra_packages" ]]; then
  for pkg in $extra_packages; do
    info "Installing $pkg by pip..."
    python -m pip install "$pkg"
  done
fi

if [[ -n "$extra_repos" ]]; then
  for repo in $extra_repos; do
    info "Cloning $repo by git..."
    git clone "$repo" --depth=1
  done
fi

if [[ -n "$pre_render" ]]; then
  info "Run pre compile commands"
  eval "$pre_render"
fi

info "Rendering..."
if [[ $community == true ]]; then
  for sce in $scene_names; do
    python -m manim "$source_file" $sce ${args[@]}
    if [ $? -ne 0 ]; then
      error "manim render error"
    fi
  done
else
  for sce in $scene_names; do
    python manim.py "$source_file" $sce ${args[@]}
    if [ $? -ne 0 ]; then
      error "manim render error"
    fi
  done
fi

if [[ -n "$post_render" ]]; then
  info "Run post compile commands"
  eval "$post_render"
fi

info "Searching outputs..."
cnt=0
videos_path="/github/workspace/media/videos/"
for sce in $scene_names; do
  video=$(find ${videos_path} -name "${sce}.mp4" -o -name "${sce}.mov" -o -name "${sce}.png")
  output[$cnt]=$video
  cnt=$cnt+1
done

mkdir /github/workspace/outputs
for file in ${output[@]}; do
  cp $file "/github/workspace/outputs/"
done

echo "All ${#output[@]} outputs: ${output[@]}"
ls /github/workspace/outputs
echo "::set-output name=video_path::./outputs/*"
