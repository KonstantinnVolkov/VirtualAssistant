unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, ShellAPI;

type

  TUsefulData = record
    Req: String[255];
    case TypeOfReq: boolean of
      true: (Ans: String[255]);
      false: (
                NumberOfAction: integer;
                Link: ShortString
             );
  end;

  TGreeting = record
    Greeting: ShortString;
  end;

  TJoke = record
    Joke: ShortString;
  end;

  TForm1 = class(TForm)
    AddCB: TComboBox;
    AddButton: TButton;
    AddMemo: TMemo;
    ActionNumber: TMemo;
    ActionCB: TComboBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    LinkEdit: TEdit;
    Label3: TLabel;
    procedure AddButtonClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddButtonClick(Sender: TObject);
var
  greeting: TGreeting;
  Greetings: File of TGreeting;
  Joke: TJoke;
  Jokes: file of TJoke;
  Brains: file of TUsefulData;
  data: TUsefulData;
  i: byte;
  buf: string;
  ErrorPos: integer;
begin
  case AddCB.ItemIndex of
  0:
    begin
      greeting.Greeting := '';
      for I := 0 to AddMemo.Lines.Count-1 do
        greeting.Greeting := greeting.Greeting + AddMemo.Lines[i];

      assignFile(greetings,'G:\CourseProject\26.05\Win32\Debug\Greetings.txt');
      reset(greetings);
      seek(Greetings,fileSize(Greetings));
      write(greetings, greeting);
      CloseFile(greetings);

      AddMemo.Lines.Clear;
    end;

  1:
    begin
      data.Req := '';
      for I := 0 to AddMemo.Lines.Count-1 do
      begin
        data.Req := data.Req + AddMemo.Lines[i];
      end;

      case ActionCB.ItemIndex of
      0: Data.TypeOfReq := True;

      1: Data.TypeOfReq := False;
      end;

      data.Ans := '';
      data.NumberOfAction := 0;
      case data.TypeOfReq of
      True:
        begin
          for I := 0 to ActionNumber.Lines.Count-1 do
          begin
            data.Ans := data.Ans + ActionNumber.Lines[i];
          end;
        end;

      False:
        begin
          val (ActionNumber.Lines[0], Data.NumberOfAction, ErrorPos);
          if ErrorPos <> 0 then
          begin
            ShowMessage('В поле добавления номера действия необходимо ввести целое число!');
            ActionNumber.Lines.Clear;
            exit;
          end;

          data.Link := LinkEdit.Text;
          LinkEdit.Clear;

        end;

      end;
      AssignFile(Brains, 'G:\CourseProject\26.05\Win32\Debug\Brains.txt');
      reset(Brains);
      seek(Brains, FileSize(Brains));
      write(Brains, Data);
      closeFile(Brains);

      AddMemo.Lines.Clear;
      ActionNumber.Lines.Clear;
    end;

  2:
    begin
      Joke.Joke := '';
      for I := 0 to AddMemo.Lines.Count-1 do
      begin
        joke.Joke := joke.Joke + AddMemo.Lines[i];
      end;

      AssignFile(Jokes,'G:\CourseProject\26.05\Win32\Debug\Jokes.txt');
      reset(Jokes);
      Seek(Jokes, FileSize(Jokes));
      Write(Jokes, Joke);
      CloseFile(Jokes);

      AddMemo.Lines.Clear;
    end;
  end;

end;
   
procedure TForm1.N1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'README.txt', nil, nil, SW_SHOWNORMAL);
end;

end.
{
  Greetings:
    Здравствуйте! Чем я могу вам помочь?┐Виртуальный ассистент Eve готов к работе!┐Привет! Чем могу помочь?┐Привет!┐Hello world!┐
    расскажи анекдот¬анекдот¬расскажи шутку¬шутка¬анекдот¬прикол¬расскажи прикол
    открой блокнот¬открй блокнот¬аткрой блокнот¬открой блакнот¬аткрой блакнот¬запусти блокнот¬сделай запись в блокноте¬запусти блакнот¬
    C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\notepad.exe
}
