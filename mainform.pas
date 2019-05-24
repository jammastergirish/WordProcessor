unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, Printers, Clipbrd, Buttons, ToolWin, ExtCtrls;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Replace1: TMenuItem;
    Find1: TMenuItem;
    N4: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    N5: TMenuItem;
    Undo1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    N3: TMenuItem;
    Font1: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FontDialog: TFontDialog;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    FindDialog: TFindDialog;
    ReplaceDialog: TReplaceDialog;
    PopupMenu: TPopupMenu;
    Editor: TRichEdit;
    N6: TMenuItem;
    WordWrap1: TMenuItem;
    Delete1: TMenuItem;
    ToolBar: TToolBar;
    NewButton: TSpeedButton;
    OpenButton: TSpeedButton;
    SaveButton: TSpeedButton;
    PrintButton: TSpeedButton;
    CopyButton: TSpeedButton;
    CutButton: TSpeedButton;
    UndoButton: TSpeedButton;
    PasteButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Bar1: TSpeedButton;
    Bar2: TSpeedButton;
    Bar3: TSpeedButton;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure WordWrap1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
  public
    procedure DisplayHint(Sender: TObject);
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.FormCreate(Sender: TObject);
begin
   Application.OnHint := DisplayHint;
end;

procedure TMain.DisplayHint(Sender: TObject);
begin
  if Length(Application.Hint) > 0 then
  begin
    StatusBar.SimplePanel := True;
    StatusBar.SimpleText := GetLongHint(Application.Hint);
  end
  else StatusBar.SimplePanel := False;
end;

procedure TMain.New1Click(Sender: TObject);
begin
   Editor.Lines.Clear;
   SaveDialog.FileName := '';
   OpenDialog.FileName := '';
end;

procedure TMain.Open1Click(Sender: TObject);
begin
   with  OpenDialog do
   if execute then
   begin
   Editor.Lines.LoadFromFile(FileName);
   HistoryList.Add(Filename);
   SaveDialog.FileName := FileName;
   FileName := '';
   end;
end;

procedure TMain.Save1Click(Sender: TObject);
begin
   if SaveDialog.FileName =  ''
   then
   SaveAs1.Click
   else
   Editor.Lines.SaveToFile(SaveDialog.FileName)
end;

procedure TMain.SaveAs1Click(Sender: TObject);
begin
   with SaveDialog do
   if execute then
   begin
   Editor.Lines.SaveToFile(FileName);
   end;
end;

procedure TMain.Print1Click(Sender: TObject);
   var
   POutput : TextFile;
   N    : LongInt;
begin
   if PrintDialog.Execute then
   begin
   AssignPrn(POutput);
   Rewrite(POutput);
   Printer.Canvas.Font := Editor.Font;
   for N := 0 to Editor.Lines.Count - 1 do
   Writeln(POutput, Editor.Lines [N]);
   CloseFile(POutput);
   end;
end;

procedure TMain.PrintSetup1Click(Sender: TObject);
begin
   PrinterSetupDialog.Execute;
end;

procedure TMain.Edit1Click(Sender: TObject);
var
  HasSelection: Boolean;
begin
 HasSelection := Editor.SelLength <> 0;

 Cut1.Enabled := HasSelection;
 Copy1.Enabled := HasSelection;
 Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
 Delete1.Enabled := HasSelection;

 CutButton.Enabled := Cut1.Enabled;
 CopyButton.Enabled := Copy1.Enabled;
 PasteButton.Enabled := Paste1.Enabled;
 DeleteButton.Enabled := Delete1.Enabled;
end;

procedure TMain.Undo1Click(Sender: TObject);
begin
   with Editor do
   if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TMain.Cut1Click(Sender: TObject);
begin
   Editor.CutToClipboard;
end;

procedure TMain.Copy1Click(Sender: TObject);
begin
   Editor.CopyToClipboard;
end;

procedure TMain.Paste1Click(Sender: TObject);
begin
   Editor.PasteFromClipboard;
end;

procedure TMain.Delete1Click(Sender: TObject);
begin
   Editor.ClearSelection;
end;

procedure TMain.Find1Click(Sender: TObject);
begin
   FindDialog.Execute;
end;

procedure TMain.FindDialogFind(Sender: TObject);
var
   Buff, P, FT : PChar;
   BuffLen : Word;
begin
   with Sender as TFindDialog do
   begin
   GetMem(FT, Length(FindText) + 1);
   StrPCopy(FT, FindText);
   BuffLen := Editor.GetTextLen + 1;
   GetMem(Buff, BuffLen);
   Editor.GetTextBuf(Buff, BuffLen);
   P := Buff + Editor.SelStart + Editor.SelLength;
   P := StrPos(P,  FT);
   if P = NIL then MessageBeep(0)
   else
    begin
    Editor.SelStart := P - Buff;
    Editor.SelLength := Length(FindText);
    end;
   FreeMem(FT, Length(FindText) + 1);
   FreeMem(Buff, BuffLen);
   end;
end;

procedure TMain.Replace1Click(Sender: TObject);
begin
   ReplaceDialog.Execute;
end;

procedure TMain.ReplaceDialogReplace(Sender: TObject);
begin
   with Sender as TReplaceDialog do
   while True do
   begin
   if Editor.SelText <> FindText then
   FindDialogFind(Sender);
   if Editor.SelLength = 0 then Break;
   Editor.SelText := ReplaceText;
   if not (FrReplaceAll in Options) then Break;
   end;
end;

procedure TMain.WordWrap1Click(Sender: TObject);
begin
   if WordWrap1.Checked = True then
    begin
    WordWrap1.Checked := False;
    Editor.Wordwrap := False;
    end
   else if WordWrap1.Checked = False then
    begin
    WordWrap1.Checked := True;
    Editor.Wordwrap := True;
    end
end;

procedure TMain.TimerTimer(Sender: TObject);
begin
   Edit1.Click;
end;

end.
