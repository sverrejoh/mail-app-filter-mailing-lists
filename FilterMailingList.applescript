-- Filters Mailing lists into separate IMAP folders.
--
-- Author: sverre.johansen@gmail.com
-- Usage:
-- - Make a Apple Mail filter that matches on List-Id header. 
--     I use "List-Id" "Does not contain" "NO MATCH", as Apple Mail does not support checking for Header.
-- 	  (I *think* this only matches on mail with this header set :)
-- - Choose "Run AppleScript" and this script as target.
using terms from application "Mail"
	on perform mail action with messages theSelectedMessages for rule theRule
		repeat with filteredMessage in theSelectedMessages
			set messageHeaders to headers of filteredMessage
			-- Look for mailing list header
			repeat with msgHeader in messageHeaders
				set headerName to name of msgHeader
				set headerContent to content of msgHeader
				if headerName = "List-Id" then
					-- Folder name, everything between < and >
					set listName to text ((offset of "<" in headerContent) + 1) thru ((offset of ">" in headerContent) - 1) of headerContent
					set mailboxName to "INBOX.Lists/" & listName
					
					-- Find or create IMAP Mailbox
					set mailAccount to account of mailbox of filteredMessage
					try
						set filterMailbox to mailbox mailboxName of mailAccount
					on error
						--- create mailbox
						tell mailAccount
							make new mailbox with properties {name:mailboxName}
							set filterMailbox to mailbox mailboxName of mailAccount
						end tell
					end try
					
					-- Move message to IMAP folder.
					move the filteredMessage to filterMailbox
				end if
			end repeat
		end repeat
	end perform mail action with messages
end using terms from
