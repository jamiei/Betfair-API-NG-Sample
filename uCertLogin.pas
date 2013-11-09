unit uCertLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfCertLogin = class(TForm)
    gbLoginParams: TGroupBox;
    btnLogin: TButton;
    btnCancel: TButton;
    eUsername: TEdit;
    ePassword: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    foCert: TFileOpenDialog;
    eCertFile: TEdit;
    btnOpenCert: TButton;
    Label1: TLabel;
    eKeyFile: TEdit;
    btnChooseKey: TButton;
    foKey: TFileOpenDialog;
    procedure btnOpenCertClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnChooseKeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCertLogin: TfCertLogin;

implementation

{$R *.dfm}

procedure TfCertLogin.btnChooseKeyClick(Sender: TObject);
begin
  if foKey.Execute then eKeyFile.Text := foKey.FileName;
end;

procedure TfCertLogin.btnLoginClick(Sender: TObject);
begin
  if (Length(eUsername.Text) > 0) and (Length(ePassword.Text) > 0) and (Length(eCertFile.Text) > 0) and (Length(eKeyFile.Text) > 0) then
  begin
    //
  end;
end;

procedure TfCertLogin.btnOpenCertClick(Sender: TObject);
begin
  if foCert.Execute then eCertFile.Text := foCert.FileName;
end;

end.
