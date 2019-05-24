program word;

uses
  Forms,
  mainform in 'mainform.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'GirishSoft Word';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
