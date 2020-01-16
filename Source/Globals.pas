unit Globals;

interface

{$I ARPLUS.INC}

resourcestring
  sConfirmKeyOverwrite = 'There is already an Add/Remove entry called "%s". Do you want to overwrite it?';
  sConfirmKeyDeletion = 'Are you sure you want to delete "%s" from the ' +
    'Add/Remove Programs list?'#13#10#13#10 +
    'WARNING: You should only delete the entries for programs that you ' +
    'know for sure that are no longer on your computer. If the program ' +
    'is still on your computer and you delete it from the Add/Remove list, ' +
    'you may not be able to uninstall it later.'#13#10#13#10 +
    'Note: If the program has a question mark near its name in the list, ' +
    'it does not mean for sure that the program is no longer on your  ' +
    'computer. To check if the program is really gone, please first try '+
    'to uninstall it.';

  sUnableToCreateKey = 'Unable to create the new entry.';
  sUnableToEditKey = 'Unable to modify the entry.';

  sStatusBarAdvice = 'Double-click a program to uninstall it or modify its installed components';

  sAdviceBadProgram = 'It seems that the uninstall program for %s ' +
    '(or one of its components) is missing. It is possible that you ' +
    'have already removed this program from your computer. To check if ' +
    'the program is really gone, please try to uninstall it by ' +
    'double-clicking its name in the list.';

  sOrderFileName = 'order.doc';

implementation

end.
