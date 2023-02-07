

export MIRRORS='https://dl-cdn.alpinelinux.org/alpine https://mirrors.aliyun.com/alpine https://mirrors.nju.edu.cn/alpine https://mirrors.tuna.tsinghua.edu.cn/alpine'
export ROOT=/
export APKREPOS_PATH=${ROOT}etc/apk/repositories


get_hostname_from_url() {
  local n="${1#*://}"
  echo ${n%%/*}
}
time_cmd() {
  local start="$(cut -d ' ' -f1 /proc/uptime)"
  $@ >&2 || return
  awk -v start=$start -v end=$(cut -d ' ' -f1 /proc/uptime) \
    'BEGIN {print end - start; exit}'
}

get_alpine_release() {
	local version="$(cat "${ROOT}"etc/alpine-release 2>/dev/null)"
	case "$version" in
		*_git*|*_alpha*) release="edge";;
		[0-9]*.[0-9]*.[0-9]*)
			# release in x.y.z format, cut last digit
			release=v${version%.[0-9]*};;
		*)	# fallback to edge
			release="edge";;
	esac
}

find_fastest_mirror() {
  local url=
  local arch="$(apk --print-arch)"
  for url in $MIRRORS; do
    # warm up the dns cache
    nslookup $(get_hostname_from_url $url) >/dev/null 2>&1
    local time="$(time_cmd wget --spider -q -T 5 -t 1 \
      ${url%/}/edge/main/$arch/APKINDEX.tar.gz)"
    if [ -n "$time" ]; then
      echo "$time $url"
    fi
  done | tee /dev/stderr | sort -nk1,1 | head -n1 | cut -d' ' -f2
}

add_mirror() {
  local mirror="$1"
  mkdir -p "${APKREPOS_PATH%/*}"
  echo "${mirror%/}/${release}/main" >> $APKREPOS_PATH
  echo "${community_prefix}${mirror%/}/${release}/community" >> $APKREPOS_PATH
  case "$release" in
  v[0-9]*)
    echo "#${mirror%/}/edge/main" >> $APKREPOS_PATH;
    echo "#${mirror%/}/edge/community" >> $APKREPOS_PATH;;
  esac
  echo "#${mirror%/}/edge/testing" >> $APKREPOS_PATH
  echo "" >> $APKREPOS_PATH
  echo "Added mirror $(get_hostname_from_url $mirror)"
}

add_fastest_mirror() {
  echo "Finding fastest mirror... "
  local fastest="$(find_fastest_mirror)"
  if [ -z "$fastest" ]; then
    echo "Warning! No mirror found"
    return 1
  fi
  add_mirror "$fastest"
}

rm -f $APKREPOS_PATH
get_alpine_release
add_fastest_mirror
