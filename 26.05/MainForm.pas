unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, APIUnit, Math,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.Buttons, Vcl.OleServer, SpeechLib_TLB,
  Vcl.WinXPickers, Vcl.WinXCalendars, Vcl.Grids, Vcl.Samples.Calendar,
  System.Notification;

type

  TGreeting = record
    Greeting: ShortString;
  end;

  TForm1 = class(TForm)
    BWeather: TButton;
    BAfisha: TButton;
    BNews: TButton;
    Label1: TLabel;
    ColorDialog: TColorDialog;
    ERequest: TEdit;
    SettingsPanel: TPanel;
    OpenSettingsButton: TBitBtn;
    CloseSettingsButton: TBitBtn;
    MDialogue: TMemo;
    Timer1: TTimer;
    OffLight: TBitBtn;
    ThemeLabel: TLabel;
    AddDialogue: TBitBtn;
    Label2: TLabel;
    SpeakerButton: TBitBtn;
    Label3: TLabel;
    SpVoice1: TSpVoice;
    procedure BWeatherClick(Sender: TObject);
    procedure BAfishaClick(Sender: TObject);
    procedure BNewsClick(Sender: TObject);
    procedure ERequestKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenSettingsButtonClick(Sender: TObject);
    procedure CloseSettingsButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure OffLightClick(Sender: TObject);
    procedure AddDialogueClick(Sender: TObject);
    procedure SpeakerButtonClick(Sender: TObject);
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
  Flag, LightFlag, Speaker, AnsNotFound, OpenFlag: boolean;
  NotesArrCount: integer;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  greetings: file of TGreeting;
  GreetArr: array of string;
  buf: TGreeting;
  phrase: String;
  i, j: byte;
  list: APIUnit.TList;
begin
  NotesArrCount := 1;
  OpenFlag := False;
  SettingsPanel.Width := 45;
  LightFlag := false;
  Speaker := false;
  AnsNotFound := false;
  SystemParametersInfo(SPI_SETBEEP, 0, nil, SPIF_SENDWININICHANGE);

  randomize;
  assignFile(greetings, 'Greetings.txt');
  reset(greetings);
  if FileSize(greetings) = 0 then exit;
  seek (greetings, 0 );
  read(Greetings, buf);

  phrase := '';
  i := 1;
  j := 0;
  setLength(GreetArr, 1);
  while True do
  begin
    if buf.Greeting[i] = '┐' then
    begin
      delete(buf.Greeting, 1, length(phrase)+1 );
      GreetArr[j] := phrase;
      phrase := '';
      i := 1;
      inc(j);
      if buf.Greeting = '' then break;
      SetLength(GreetArr,j+1);
    end
    else
    begin
      phrase := phrase + buf.Greeting[i];
      inc(i);
    end;
  end;
  MDialogue.Visible := true;
  Phrase := GreetArr[ random ( Length(GreetArr) ) ];
  MDialogue.Lines.Add('Eve: ' + phrase );

  CreateList;
end;

procedure TForm1.ERequestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  enter = 13;
var
  k, ErrPos: integer;
begin
  if key = enter then
  begin
    if OpenFlag then
    begin
      APIUnit.CreateList;
      OpenFlag := False;
    end;

    if (ERequest.Text = '') then  exit;

    if AnsNotFound then
    begin
      AnsNotFound := false;
      val(ERequest.Text, k, ErrPos);
      case k of
      1:
        begin
          ShellExecute(0, 'open', 'G:\CourseProject\AddDialogue\Final\Win32\Debug\AddRecord.exe',
            nil, nil, SW_SHOWNORMAL);
          OpenFlag := true;
          ERequest.Clear;
         exit;
        end;
      2:
        begin
          MDialogue.Lines.Add('Eve: Хорошо');
          Sleep(500);
          ShellExecute(0, 'open', PWideChar('https://www.google.com/search?q='+UserRequest),
            nil, nil, SW_SHOWNORMAL);
          ERequest.Clear;
          exit;
        end;
      end;

      if (ERequest.Text = 'добавить') or (ERequest.Text = 'добавь') or (ERequest.Text = 'Добавить') or (ERequest.Text = 'Добавь') then
      begin
        ShellExecute(0, 'open', 'G:\CourseProject\AddDialogue\Final\Win32\Debug\AddRecord.exe',
            nil, nil, SW_SHOWNORMAL);
        OpenFlag := true;
        ERequest.Clear;
         exit;
      end
      else if (ERequest.Text = 'найди') or (ERequest.Text = 'поиск') or (ERequest.Text = 'Найди') or (ERequest.Text = 'Поиск')then
      begin
        MDialogue.Lines.Add('Eve: Хорошо');
          Sleep(500);
          ShellExecute(0, 'open', PWideChar('https://www.google.com/search?q='+UserRequest),
            nil, nil, SW_SHOWNORMAL);
          ERequest.Clear;
          exit;
      end;
    end;

    UserRequest := trim(ERequest.Text);
    MDialogue.lines.Add('Вы: '+ UserRequest);
    FormatInput(UserRequest);

    ERequest.Clear;
    FindAns(UserRequest, Speaker, AnsNotFound);
    if AnsNotFound then
    begin
      MainForm.Form1.MDialogue.Lines.Add('Eve: К сожалению, мне не удалось найти ответ на ваш запрос. В этом случае вы можете добавить запрос и действие сами (Настройки -> Добавить новый диалог) или я найду его в интернете');
      MainForm.Form1.MDialogue.Lines.Add('1: Добавить');
      MainForm.Form1.MDialogue.Lines.Add('2: Найти в интернете');
    end;

  end;
end;

//Apps

procedure TForm1.AddDialogueClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'G:\CourseProject\AddDialogue\Final\Win32\Debug\AddRecord.exe',
    nil, nil, SW_SHOWNORMAL) ;
  OpenFlag := true;
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

//Interface

procedure TForm1.FormShow(Sender: TObject);
begin
  ERequest.SetFocus;
end;

procedure TForm1.SpeakerButtonClick(Sender: TObject);
begin
  if not Speaker then
  begin
    speaker := true;
    SpeakerButton.Glyph.LoadFromFile('G:\CourseProject\Images\Sound\BMP\outline_record_voice_over_black_18dp.bmp');
  end
  else
  begin
    speaker := false;
    SpeakerButton.Glyph.LoadFromFile('G:\CourseProject\Images\Sound\BMP\outline_voice_over_off_black_18dp.bmp');
  end;
end;

procedure TForm1.OffLightClick(Sender: TObject);
var
  flag: Boolean;
begin
  case LightFlag of
  false:
    begin
      form1.color := clBlack;
      mDialogue.Color := clBlack;
      ERequest.color := clBlack;

      ERequest.Font.Color := clYellow;
      label1.font.Color := clYellow;
      label2.font.Color := clYellow;
      Label3.Font.Color := clYellow;
      ThemeLabel.font.Color := clYellow;
      MDialogue.Font.Color := clYellow;

      MDialogue.BorderStyle := bsNone;
      LightFlag := true;
      exit;
    end;

  true:
    begin
      form1.color := clWhite;
      mDialogue.Color := clWhite;
      ERequest.color := clWhite;

      ERequest.Font.Color := clBlack;
      mDialogue.Font.Color := clBlack;
      label1.font.Color := clBlack;
      label2.font.Color := clBlack;
      Label3.Font.Color := clBlack;
      ThemeLabel.font.Color := clBlack;

      MDialogue.BorderStyle := bsSingle;
      LightFlag := false;
      exit;
    end;
  end;

end;

procedure TForm1.OpenSettingsButtonClick(Sender: TObject);
begin
  flag := true;
  Timer1.Interval := 10;
  OpenSettingsButton.Visible := False;
  MDialogue.Visible := False;
  timer1.Enabled := true;
end;

procedure TForm1.CloseSettingsButtonClick(Sender: TObject);
begin
  flag := false;
  Timer1.Interval := 10;
  OpenSettingsButton.Visible := true;
  MDialogue.Visible := true;
  timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  case flag of
  True:
    begin
      if SettingsPanel.Width <> 345 then
      begin
        SettingsPanel.Width := SettingsPanel.Width + 20;
      end
      else
        Timer1.Enabled := false;
    end;

  False:
     begin
      if SettingsPanel.Width <> 45 then
      begin
        SettingsPanel.Width := SettingsPanel.Width - 20;
      end
      else
      begin
        Timer1.Enabled := false;
        MDialogue.Visible := true;
      end;
    end;
  end;
end;

end.
