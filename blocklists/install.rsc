/system script
add name="dl-blocklist-de" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/blocklist-de.rsc" mode=https dst-path=blocklist-de.rsc
    :if ([:len [/file get blocklist-de.rsc contents]] > 0) do={
        :log info "Downloaded blocklist-de.rsc successfully"
    } else={
        :log error "Failed to download blocklist-de.rsc"
        /file remove blocklist-de.rsc
    }
}
add name="replace-blocklist-de" source={/ip firewall address-list remove [find where list="blocklist-de"]; /import file-name=blocklist-de.rsc; /file remove blocklist-de.rsc}
add name="dl-dshield-recommended" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/dshield-recommended.rsc" mode=https dst-path=dshield-recommended.rsc
    :if ([:len [/file get dshield-recommended.rsc contents]] > 0) do={
        :log info "Downloaded dshield-recommended.rsc successfully"
    } else={
        :log error "Failed to download dshield-recommended.rsc"
        /file remove dshield-recommended.rsc
    }
}
add name="replace-dshield-recommended" source={/ip firewall address-list remove [find where list="dshield-recommended"]; /import file-name=dshield-recommended.rsc; /file remove dshield-recommended.rsc}
add name="dl-feodo-recommended" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/feodo-recommended.rsc" mode=https dst-path=feodo-recommended.rsc
    :if ([:len [/file get feodo-recommended.rsc contents]] > 0) do={
        :log info "Downloaded feodo-recommended.rsc successfully"
    } else={
        :log error "Failed to download feodo-recommended.rsc"
        /file remove feodo-recommended.rsc
    }
}
add name="replace-feodo-recommended" source={/ip firewall address-list remove [find where list="feodo-recommended"]; /import file-name=feodo-recommended.rsc; /file remove feodo-recommended.rsc}
add name="dl-firehol-abusers-1d" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/firehol-abusers-1d.rsc" mode=https dst-path=firehol-abusers-1d.rsc
    :if ([:len [/file get firehol-abusers-1d.rsc contents]] > 0) do={
        :log info "Downloaded firehol-abusers-1d.rsc successfully"
    } else={
        :log error "Failed to download firehol-abusers-1d.rsc"
        /file remove firehol-abusers-1d.rsc
    }
}
add name="replace-firehol-abusers-1d" source={/ip firewall address-list remove [find where list="firehol-abusers-1d"]; /import file-name=firehol-abusers-1d.rsc; /file remove firehol-abusers-1d.rsc}
add name="dl-firehol-blocklist-net-ua" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/firehol-blocklist-net-ua.rsc" mode=https dst-path=firehol-blocklist-net-ua.rsc
    :if ([:len [/file get firehol-blocklist-net-ua.rsc contents]] > 0) do={
        :log info "Downloaded firehol-blocklist-net-ua.rsc successfully"
    } else={
        :log error "Failed to download firehol-blocklist-net-ua.rsc"
        /file remove firehol-blocklist-net-ua.rsc
    }
}
add name="replace-firehol-blocklist-net-ua" source={/ip firewall address-list remove [find where list="firehol-blocklist-net-ua"]; /import file-name=firehol-blocklist-net-ua.rsc; /file remove firehol-blocklist-net-ua.rsc}
add name="dl-firehol-level1" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/firehol-level1.rsc" mode=https dst-path=firehol-level1.rsc
    :if ([:len [/file get firehol-level1.rsc contents]] > 0) do={
        :log info "Downloaded firehol-level1.rsc successfully"
    } else={
        :log error "Failed to download firehol-level1.rsc"
        /file remove firehol-level1.rsc
    }
}
add name="replace-firehol-level1" source={/ip firewall address-list remove [find where list="firehol-level1"]; /import file-name=firehol-level1.rsc; /file remove firehol-level1.rsc}
add name="dl-spamhaus-drop" source={
    /tool fetch url="https://raw.githubusercontent.com/nekirc/blockList-raw/refs/heads/main/blocklists/spamhaus-drop.rsc" mode=https dst-path=spamhaus-drop.rsc
    :if ([:len [/file get spamhaus-drop.rsc contents]] > 0) do={
        :log info "Downloaded spamhaus-drop.rsc successfully"
    } else={
        :log error "Failed to download spamhaus-drop.rsc"
        /file remove spamhaus-drop.rsc
    }
}
add name="replace-spamhaus-drop" source={/ip firewall address-list remove [find where list="spamhaus-drop"]; /import file-name=spamhaus-drop.rsc; /file remove spamhaus-drop.rsc}

/system scheduler
add interval=1d name="dl-blocklist-de-scheduled" start-time=00:05:00 on-event=dl-blocklist-de
add interval=1d name="install-blocklist-de-scheduled" start-time=00:10:00 on-event=replace-blocklist-de
add interval=1d name="dl-dshield-recommended-scheduled" start-time=00:15:00 on-event=dl-dshield-recommended
add interval=1d name="install-dshield-recommended-scheduled" start-time=00:20:00 on-event=replace-dshield-recommended
add interval=1d name="dl-feodo-recommended-scheduled" start-time=00:25:00 on-event=dl-feodo-recommended
add interval=1d name="install-feodo-recommended-scheduled" start-time=00:30:00 on-event=replace-feodo-recommended
add interval=1d name="dl-firehol-abusers-1d-scheduled" start-time=00:35:00 on-event=dl-firehol-abusers-1d
add interval=1d name="install-firehol-abusers-1d-scheduled" start-time=00:40:00 on-event=replace-firehol-abusers-1d
add interval=1d name="dl-firehol-blocklist-net-ua-scheduled" start-time=00:45:00 on-event=dl-firehol-blocklist-net-ua
add interval=1d name="install-firehol-blocklist-net-ua-scheduled" start-time=00:50:00 on-event=replace-firehol-blocklist-net-ua
add interval=1d name="dl-firehol-level1-scheduled" start-time=00:55:00 on-event=dl-firehol-level1
add interval=1d name="install-firehol-level1-scheduled" start-time=00:60:00 on-event=replace-firehol-level1
add interval=1d name="dl-spamhaus-drop-scheduled" start-time=00:65:00 on-event=dl-spamhaus-drop
add interval=1d name="install-spamhaus-drop-scheduled" start-time=00:70:00 on-event=replace-spamhaus-drop
