# Mikrotik Blocklists

This repository contains automatically generated Mikrotik RouterOS script (`.rsc`) files for use in firewall address lists. These lists are designed to block connections from known malicious IP addresses and networks, enhancing the security of your Mikrotik router. The lists are updated daily.

## Blocklist Files

The `blocklists` directory contains the following `.rsc` files, which are automatically generated and updated:

| Filename                     | Address List Name in RouterOS      | Description                                                                                                                                                                                                                                                           |
| :--------------------------- | :------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `spamhaus-drop.rsc`          | `spamhaus-drop`                       | Contains networks allocated to spam operations. Recommended as a first line of defense. (Source: [Spamhaus DROP](https://www.spamhaus.org/drop/))                                                                                                           |
| `dshield-recommended.rsc`   | `dshield-recommended`                | Derived from the DShield Recommended Block List (Top 20). Includes networks currently involved in attacks. More aggressive, so monitor for false positives. (Source: [DShield Recommended Block List](https://www.dshield.org/block.txt))                         |
| `blocklist-de.rsc`          | `blocklist-de`                       | Includes IPs reported for various malicious activities (attacks on SSH, mail servers, web servers, etc.). (Source: [blocklist.de](https://www.blocklist.de/))                                                                                                  |
| `feodo-recommended.rsc`     | `feodo-recommended`                  | Based on the Feodo Tracker, focusing on infrastructure related to the Feodo trojan (Cridex/Bugat). A more specialized list. (Source: [Feodo Tracker](https://feodotracker.abuse.ch/blocklist/))                                                            |
| `firehol-level1.rsc`        | `firehol-level1`                     | A relatively safe list for general use, blocking IPs confirmed as attackers, malware distributors, or botnet controllers in the last few days. (Source: [FireHOL Level 1](https://iplists.firehol.org/?ipset=firehol_level1))                             |
| `firehol-abusers-1d.rsc`   | `firehol-abusers-1d`                  | Contains IPs seen attacking in the last 24 hours. (Source: [FireHOL Abusers 1d](https://iplists.firehol.org/?ipset=firehol_abusers_1d))                                                                                                                    |
| `firehol-blocklist-net-ua.rsc` | `firehol-blocklist-net-ua`        | Contains IPs registered to organizations in Ukraine. Potentially useful for geo-blocking, but use with extreme caution. Can easily block legitimate traffic. (Source: [FireHOL blocklist-net-ua](https://github.com/firehol/blocklist-ipsets))         |
| `blocklists_combined.rsc`   | `combined-blocklist`                  | An *aggregated and deduplicated* list of *all* the other blocklists. Combines all entries, removes duplicates, and aggregates overlapping CIDR blocks. **Generally recommended for comprehensive coverage and best performance.**                      |

## Usage

1.  **Download:** The blocklists are automatically generated and updated daily.  You do *not* need to download the `.rsc` files manually.

2.  **Automated Updates (Recommended):** The easiest and most secure way to use these blocklists is to configure your Mikrotik router to automatically download and import the `install.rsc` file.  This script handles downloading and importing all individual blocklist files.

    *   Upload the `install.rsc` file (from the `blocklists` directory) to your Mikrotik router using Winbox (Files -> Upload) or the `/file upload` command via SSH.
    *   Open a terminal on your Mikrotik and run:

        ```routeros
        /import file-name=blocklists/install.rsc verbose=yes
        ```

    *   This will create the necessary scripts and schedulers to automatically download and import the blocklists daily.  You can verify the schedules with:

        ```routeros
        /system scheduler print
        ```

    *   You can verify the address lists with:

        ```routeros
        /ip firewall address-list print
        ```

3.  **Manual Updates (Not Recommended):** If you prefer *not* to use the automated `install.rsc` method (for example, if you want to use only *some* of the lists, or the combined list), you can manually download the individual `.rsc` files and import them:

    *   Download the desired `.rsc` files.
    *   Upload them to your Mikrotik router.
    *   Import them using the `/import` command in the terminal:
        ```routeros
        /import file-name=blocklists/spamhaus-drop.rsc verbose=yes
        /import file-name=blocklists/blocklists_combined.rsc verbose=yes
        # ... import other files as needed ...
        ```

4.  **Firewall Rules:**  Add firewall rules to your Mikrotik configuration to *use* these address lists.  The most common approach is to drop all incoming connections from IPs in the lists.  Place these rules at the *top* of your `input` chain in `/ip firewall filter`:

    ```routeros
    /ip firewall filter
    add action=drop chain=input src-address-list="spamhaus-drop" comment="Block Spamhaus DROP"
    add action=drop chain=input src-address-list="dshield-recommended" comment="Block DShield Recommended"
    add action=drop chain=input src-address-list="combined-blocklist" comment="Block Combined List"
    # ... add rules for other lists as needed ...
    ```

    It's generally recommended to use the `combined-blocklist` for comprehensive coverage and better performance.  If you are *not* using the combined list, you'll need to add a separate `drop` rule for *each* address list you want to use.

## Important Considerations

*   **False Positives:** While these blocklists are generally reliable, there is always a *small* risk of false positives (blocking legitimate traffic).  Monitor your network and logs, and be prepared to whitelist any incorrectly blocked IPs if necessary. The `combined-blocklist` minimizes this risk through aggregation.
*   **Performance:**  Adding a large number of firewall rules can impact your router's performance.  Using the *combined* list is generally more efficient than using many individual lists.  Monitor your router's CPU and memory usage.
*   **DDoS Mitigation:** These blocklists help prevent connections from known bad actors, but they are *not* a complete solution for Distributed Denial of Service (DDoS) attacks.  For robust DDoS protection, consider a dedicated DDoS mitigation service.
*   **Regular Updates:**  The threat landscape is constantly evolving.  The `install.rsc` script ensures your blocklists are automatically updated daily.
* **Repository URL:** The install.rsc script downloads from: `https://github.com/nekirc/blockList-raw`