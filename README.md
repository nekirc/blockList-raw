# Mikrotik Blocklists

This repository contains automatically generated Mikrotik RouterOS script (`.rsc`) files for use in firewall address lists.  These lists are designed to block connections from known malicious IP addresses and networks, enhancing the security of your Mikrotik router.  The lists are updated daily.

## Blocklist Files

The `blocklists` directory contains the following `.rsc` files:

*   **`spamhaus-drop.rsc`:**  This list is generated from the [Spamhaus Don't Route Or Peer (DROP)](https://www.spamhaus.org/drop/) list.  It contains networks allocated to spam operations.  Spamhaus recommends using the DROP list as a first line of defense.

*   **`dshield-recommended.rsc`:**  This list is derived from the [DShield Recommended Block List](https://www.dshield.org/block.txt).  DShield, part of the SANS Internet Storm Center, aggregates data from numerous sources to identify the top networks currently involved in attacks. This list is more aggressive than some others, so use it with caution and monitor for false positives.  It uses the "Top 20" list format.

*   **`blocklist-de.rsc`:**  This list comes from [blocklist.de](https://www.blocklist.de/). It includes IPs that have been reported for various malicious activities, including attacks on SSH, mail servers, web servers, and more.  Blocklist.de aggregates reports from multiple sources.

*   **`feodo-recommended.rsc`:** This list is based on the [Feodo Tracker](https://feodotracker.abuse.ch/blocklist/) provided by abuse.ch. Feodo Tracker focuses specifically on tracking and blocking infrastructure related to the Feodo trojan (also known as Cridex or Bugat), a banking trojan.  This is a more specialized list.

*   **`firehol-level1.rsc`:**  This list comes from the [FireHOL Level 1](https://iplists.firehol.org/?ipset=firehol_level1) blocklist.  FireHOL Level 1 is designed to be a relatively safe list for general use, blocking IPs that have been confirmed as attackers, malware distributors, or botnet controllers in the last few days.

*  **`firehol-abusers-1d.rsc`**: Contains IPs seen attacking in the last 24 hours.

*  **`firehol-blocklist-net-ua.rsc`**: Firehol list contains IPs registered in Ukraine.

*   **`blocklists_combined.rsc`:** This file contains an *aggregated and deduplicated* list of all the other blocklists.  It combines all the entries, removes duplicates, and aggregates overlapping CIDR blocks into the smallest possible set of networks.  This is the most convenient list to use if you want comprehensive coverage, but it *may* also have a slightly higher risk of false positives (though this is minimized by the aggregation process).  **Using this combined list is generally recommended.**

## Usage

1.  **Download:** Download the `.rsc` files from the `blocklists` directory in this repository.  You can either download them individually or clone the entire repository.

2.  **Upload:** Upload the desired `.rsc` files to your Mikrotik router.  You can use the Winbox "Files" window (drag and drop) or the `/file upload` command via SSH/terminal.

3.  **Import:**  Open a terminal on your Mikrotik router (either through Winbox, WebFig, or SSH).  Use the `/import` command to import the `.rsc` files.  For example:

    ```routeros
    /import file-name=blocklists/spamhaus-drop.rsc verbose=yes
    /import file-name=blocklists/dshield-recommended.rsc verbose=yes
    /import file-name=blocklists/blocklists_combined.rsc verbose=yes
    ```

    The `verbose=yes` option provides detailed output during the import process.

4.  **Verify:**  After importing, verify that the address lists have been populated:

    ```routeros
    /ip firewall address-list print
    ```

5.  **Firewall Rules:**  Add firewall rules to your Mikrotik configuration to *use* these address lists.  The most common approach is to drop all incoming connections from IPs in the lists.  Place these rules at the *top* of your `input` chain in `/ip firewall filter`:

    ```routeros
    /ip firewall filter
    add action=drop chain=input src-address-list="spamhaus-drop" comment="Block Spamhaus DROP"
    add action=drop chain=input src-address-list="dshield-recommended" comment="Block DShield Recommended"
    add action=drop chain=input src-address-list="combined-blocklist" comment="Block Combined List"
    # ... add rules for other lists as needed ...
    ```
    It's best to use combined list - `combined-blocklist`

## Important Considerations

*   **False Positives:** While these blocklists are generally reliable, there is always a *small* risk of false positives (blocking legitimate traffic).  Monitor your network and logs, and be prepared to whitelist any incorrectly blocked IPs if necessary. The `combined-blocklist` minimizes this risk through aggregation.
*   **Performance:**  Adding a large number of firewall rules can impact your router's performance.  Using the *combined* list is generally more efficient than using many individual lists.  Monitor your router's CPU and memory usage.
*   **DDoS Mitigation:** These blocklists help prevent connections from known bad actors, but they are *not* a complete solution for Distributed Denial of Service (DDoS) attacks.  For robust DDoS protection, consider a dedicated DDoS mitigation service.
*   **Regular Updates:**  The threat landscape is constantly evolving.  Make sure your Mikrotik is configured to automatically update the blocklists (as shown in the "Automated Updates" section above).

