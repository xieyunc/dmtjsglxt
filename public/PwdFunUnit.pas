unit PwdFunUnit;

interface

uses
  SysUtils,Windows,Dialogs,Forms;

const
  C1Key = 12674; //   C1 = 52845;
  C2Key = 35891; //   C2 = 22719;
  XXXKey = 'xlinuxx';  //

//-----------���ַ������м��ܺͽ��ܵļ��õĺ���----------------
Function EncryptionEngine(Src:String; Key:String; Encrypt : Boolean):string;
function EnCrypt(Sour: String):String; //����һ�������������ã�����
function DeCrypt(Sour: String):String; //����

function SetLocalSysTime(const newTime:TDateTime):Boolean; //���ñ���ϵͳʱ��

function EncryptStr(const S: string; Key: Word): string; //��������������д���е��ã�������
function DecryptStr(const S: string; Key: Word): string;

implementation


//-----------���ַ������м��ܺͽ��ܵļ��õĺ���----------------
Function EncryptionEngine(Src:String; Key:String; Encrypt : Boolean):string;
var
   idx         :integer;
   KeyLen      :Integer;
   KeyPos      :Integer;
   offset      :Integer;
   dest        :string;
   SrcPos      :Integer;
   SrcAsc      :Integer;
   TmpSrcAsc   :Integer;
   Range       :Integer;

begin
  try
     if Src='' then
     begin
       Result := '';
       Exit;
     end;

     KeyLen:=Length(Key);
     if KeyLen = 0 then key:='xlinuxx';
     KeyPos:=0;
     SrcPos:=0;
     SrcAsc:=0;
     Range:=256;
     if Encrypt then
     begin
          Randomize;
          offset:=Random(Range);
          dest:=format('%1.2x',[offset]);
          for SrcPos := 1 to Length(Src) do
          begin
               SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
               if KeyPos < KeyLen then KeyPos:= KeyPos + 1 else KeyPos:=1;
               SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
               dest:=dest + format('%1.2x',[SrcAsc]);
               offset:=SrcAsc;
          end;
     end
     else
     begin
          offset:=StrToInt('$'+ copy(src,1,2));
          SrcPos:=3;
          repeat
                SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
                if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
                TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
                if TmpSrcAsc <= offset then
                     TmpSrcAsc := 255 + TmpSrcAsc - offset
                else
                     TmpSrcAsc := TmpSrcAsc - offset;
                dest := dest + chr(TmpSrcAsc);
                offset:=srcAsc;
                SrcPos:=SrcPos + 2;
          until SrcPos >= Length(Src);
     end;
     Result:=Dest;
  except
    Result := '';
  end;
end;


////////////////////////////////////////////
// -----------   ���ܺ��� -----------     //
//                                        //
////////////////////////////////////////////
function EnCrypt(Sour: String):String;
begin
  Result := EncryptionEngine(Sour,XXXKey,True);
end;

////////////////////////////////////////////
// -----------   ���ܺ��� -----------     //
//                                        //
////////////////////////////////////////////
function DeCrypt(Sour: String):String;
begin
  Result := EncryptionEngine(Sour,XXXKey,False);
end;

{
function EnCrypt(Sour: String):String;
begin
  Result := EncryptStr(Sour,110);
end;

function DeCrypt(Sour: String):String;
begin
  Result := DecryptStr(Sour,110);
end;
}

function EncryptStr(const S: string; Key: Word): string;
var     // ����
  I : Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
   begin
    Result[I] := Char(Byte(S[I]) xor (Key shr 8));
    Key := (Byte(Result[I]) + Key) * C1Key + C2Key;
   end;
end;

function DecryptStr(const S: string; Key: Word): string;
var    // ����
  I : Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
   begin
    Result[I] := Char(Byte(S[I]) xor (Key shr 8));
    Key := (Byte(S[I]) + Key) * C1Key + C2Key;
   end;
end;

function SetLocalSysTime(const newTime:TDateTime):Boolean; //���ñ���ϵͳʱ��
var
  MyTime:TsystemTime;
begin
  FillChar(MyTime,sizeof(MyTime),#0);
  MyTime.wYear := StrToInt(FormatDateTime('yyyy', newTime));
  MyTime.wMonth := StrToInt(FormatDateTime('mm', newTime));
  MyTime.wDay := StrToInt(FormatDateTime('dd', newTime));
  MyTime.wHour := StrToInt(FormatDateTime('hh', newTime));
  MyTime.wMinute := StrToInt(FormatDateTime('nn', newTime));
  MyTime.wSecond := StrToInt(FormatDateTime('ss', newTime));
  Result := SetLocalTime(MyTime);
  //Result := SetSystemTime(MyTime);
end;

end.



