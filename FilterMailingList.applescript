using terms from application "Mail"
	on perform mail action with messages theSelectedMessages for rule theRule
		repeat with eachMessage in theSelectedMessages
			set messageHeaders to headers of eachMessage
			-- say "begin"
			repeat with msgHeader in messageHeaders
				set headerName to name of msgHeader
				set headerContent to content of msgHeader
				if headerName = "List-Id" then
					set listName to text ((offset of "<" in headerContent) + 1) thru ((offset of ">" in headerContent) - 1) of headerContent
					set mailboxName to "INBOX.Lists/" & listName
					set mailAccount to account of mailbox of eachMessage
					try
						set filterMailbox to mailbox mailboxName of mailAccount
					on error
						--- create mailbox
						tell mailAccount
							make new mailbox with properties {name:mailboxName}
							set filterMailbox to mailbox mailboxName of mailAccount
						end tell
					end try
					-- display dialog mailboxName
					move the eachMessage to filterMailbox
				end if
			end repeat
			-- say "end"
		end repeat
	end perform mail action with messages
end using terms from
