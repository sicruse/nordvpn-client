FROM alpine

LABEL maintainer="Maciej Karpusiewicz <maciej.karpusiewicz@outlook.com>"

VOLUME ["/vpn/ovpn/"]

RUN apk --no-cache --no-progress update && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl unzip iptables ip6tables jq openvpn tini && \
    mkdir -p /vpn/ovpn/

ENV URL_NORDVPN_API="https://api.nordvpn.com/server" \
    URL_RECOMMENDED_SERVERS="https://nordvpn.com/wp-admin/admin-ajax.php?action=servers_recommendations" \
    URL_OVPN_FILES="https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip" \
    MAX_LOAD=70

HEALTHCHECK --start-period=30s --timeout=15s --interval=60s --retries=2 \
            CMD curl -fL 'https://api.ipify.org' || exit 1

COPY nordvpn.sh /usr/bin
RUN ["chmod", "+x", "/usr/bin/nordvpn.sh"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/nordvpn.sh"]
