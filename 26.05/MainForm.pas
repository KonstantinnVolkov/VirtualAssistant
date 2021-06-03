unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, APIUnit, Math,
  Vcl.ToolWin, Vcl.ComCtrls;

type

  TGreeting = record
    Greeting: ShortString;
  end;

  TForm1 = class(TForm)
    BWeather: TButton;
    BAfisha: TButton;
    BNews: TButton;
    Label1: TLabel;
    Image1: TImage;
    mMenu: TMainMenu;
    darkTheme: TMenuItem;
    brightTheme: TMenuItem;
    customTheme: TMenuItem;
    ColorDialog: TColorDialog;
    ERequest: TEdit;
    PDialogue: TPanel;
    MDialogue: TMemo;
    procedure BWeatherClick(Sender: TObject);
    procedure BAfishaClick(Sender: TObject);
    procedure BNewsClick(Sender: TObject);
    procedure darkThemeClick(Sender: TObject);
    procedure brightThemeClick(Sender: TObject);
    procedure customThemeClick(Sender: TObject);
    procedure ERequestKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ShellApi;

var
  UserRequest: string;
  List: APIUnit.TList;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  greetings: file of TGreeting;
  GreetArr: array of string;
  buf: TGreeting;
  phrase: String;
  i: byte;
begin
  randomize;
  assignFile(greetings,'greetings.txt');
  rewrite(greetings);
  read(Greetings,buf);
  i := 1;
  setLength(GreetArr,i);
  while True do
  begin
    if buf.Greeting[i] = '┐' then
    begin
      buf.Greeting := delete (buf.Greeting, 1, pos('┐', buf.Greeting) );
      phrase := '';
      i := 1;
    end
    else
    begin
      phrase := phrase + buf.Greeting[i];
      inc(i);
    end;

  end;

end;

procedure TForm1.ERequestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  enter = 13;
begin
  if key = enter then
  begin
    UserRequest := trim(ERequest.Text);
    PDialogue.Visible := true;
    if (UserRequest = '') then
    begin
      MDialogue.lines.Add('Eve: Хватит баловаться!');
      exit;
    end;
    MDialogue.lines.Add('Вы: '+ UserRequest);
    FormatInput(UserRequest);
    ERequest.Clear;
    FindAns (UserRequest, List);






  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ERequest.SetFocus;
end;

procedure TForm1.customThemeClick(Sender: TObject);    //Interface
begin
  if colorDialog.Execute then
    begin
      form1.Color := colorDialog.Color;
      label1.Font.Color := clBlack;
      pdialogue.Color := colorDialog.Color;
      mDialogue.Color := colorDialog.Color;
      mDialogue.Font.Color := clBlack;
    end;
end;

procedure TForm1.darkThemeClick(Sender: TObject);
begin
  form1.color := clBlack;
  pdialogue.Color := clBlack;
  mDialogue.Color := clBlack;
  MDialogue.Font.Color := clWhite;
end;

procedure TForm1.brightThemeClick(Sender: TObject);
begin
  form1.color := clWhite;
  pdialogue.Color := clWhite;
  mDialogue.Color := clWhite;
  mDialogue.Font.Color := clBlack;
  label1.font.Color := clBlack;
end;

procedure TForm1.BAfishaClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://afisha.relax.by/',
    nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.BNewsClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.onliner.by/',
    nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.BWeatherClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.accuweather.com/ru/by/minsk/28580/weather-forecast/28580',
    nil, nil, SW_SHOWNORMAL) ;
end;

end.
{1. Голосовой ввод
 2. COM сервер
 3. некий помощник студента (справочник по Delphi, матем, физике и т.п.)
 4. Изменить ссылки быстрых кнопок
 5. Изменение темы по времени
 6. Ассистент обижается на грубые слова
 7. Ассистент может сказать какой праздник или день недели N числа
 8. Форма для добавления вопрос-ответ
}
