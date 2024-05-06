#!/bin/bash



GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}')

SUPPORT_FILES=( "/Users/$GUI_USER/Library/Application Scripts/com.microsoft.Excel"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.Office365ServiceV2"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.Outlook"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.Powerpoint"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.Word"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.errorreporting"
"/Users/$GUI_USER/Library/Application Scripts/com.microsoft.onenote.mac"
"/Users/$GUI_USER/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.excel.sfl"
"/Users/$GUI_USER/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.powerpoint.sfl"
"/Users/$GUI_USER/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.word.sfl"
"/Users/$GUI_USER/Library/Caches/Microsoft/uls/com.microsoft.autoupdate.fba"
"/Users/$GUI_USER/Library/Caches/Microsoft/uls/com.microsoft.autoupdate2"
"/Users/$GUI_USER/Library/Caches/com.microsoft.autoupdate.fba"
"/Users/$GUI_USER/Library/Caches/com.microsoft.autoupdate2"
"/Users/$GUI_USER/Library/Containers/com.microsoft.Excel"
"/Users/$GUI_USER/Library/Containers/com.microsoft.Office365ServiceV2"
"/Users/$GUI_USER/Library/Containers/com.microsoft.Outlook"
"/Users/$GUI_USER/Library/Containers/com.microsoft.Powerpoint"
"/Users/$GUI_USER/Library/Containers/com.microsoft.Word"
"/Users/$GUI_USER/Library/Containers/com.microsoft.errorreporting"
"/Users/$GUI_USER/Library/Containers/com.microsoft.onenote.mac"
"/Users/$GUI_USER/Library/Cookies/com.microsoft.autoupdate.fba.binarycookies"
"/Users/$GUI_USER/Library/Cookies/com.microsoft.autoupdate2.binarycookies"
"/Users/$GUI_USER/Library/Group Containers/UBF8T346G9.Office"
"/Users/$GUI_USER/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost"
"/Users/$GUI_USER/Library/Group Containers/UBF8T346G9.ms"
"/Users/$GUI_USER/Library/Preferences/com.microsoft.Excel.plist"
"/Users/$GUI_USER/Library/Preferences/com.microsoft.Powerpoint.plist"
"/Users/$GUI_USER/Library/Preferences/com.microsoft.Word.plist"
"/Users/$GUI_USER/Library/Preferences/com.microsoft.autoupdate.fba.plist"
"/Users/$GUI_USER/Library/Preferences/com.microsoft.autoupdate2.plist"
"/Users/$GUI_USER/Library/Saved Application State/com.microsoft.autoupdate2.savedState"
"/Users/$GUI_USER/Library/Saved Application State/com.microsoft.office.setupassistant.savedState"
"/Library/LaunchDaemons/com.microsoft.*")

APPLICATION_FILES=("/Applications/Microsoft Word.app"
"/Applications/Microsoft Excel.app"
"/Applications/Microsoft OneNote.app"
"/Applications/Microsoft Outlook.app"
"/Applications/Microsoft PowerPoint.app")

remove_supporting_files(){
  for ((i = 0; i < ${#SUPPORT_FILES[@]}; i++))
    do
        echo "Remove ${SUPPORT_FILES[$i]}"
        rm -rf "${SUPPORT_FILES[$i]}"
    done

}

remove_applications(){
  for ((i = 0; i < ${#APPLICATION_FILES[@]}; i++))
    do
        echo "Remove ${APPLICATION_FILES[$i]}"
        rm -rf "${APPLICATION_FILES[$i]}"
    done


}

quit_all_msft_apps(){
  openMSFTapps=($(pgrep Microsoft))
  for (( i = 0; i < ${#openMSFTapps[@]}; i++ )); do
    kill ${openMSFTapps[$i]}
    sleep 2
    killall "Microsoft Error Reporting"
  done

}

quit_all_msft_apps

remove_supporting_files

remove_applications











# end

