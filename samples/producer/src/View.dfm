object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Producer'
  ClientHeight = 366
  ClientWidth = 1079
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 3
    Top = 8
    Width = 1081
    Height = 605
    Caption = 'Producer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI Black'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 138
      Top = 33
      Width = 792
      Height = 37
      Caption = 'Produce messages for multiple exchanges/queues sincroniz'
    end
    object btnStop1: TButton
      Left = 138
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 0
      OnClick = btnStop1Click
    end
    object btnStart1: TButton
      Left = 18
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 1
      OnClick = btnStart1Click
    end
    object Memo1: TMemo
      Left = 18
      Top = 135
      Width = 482
      Height = 146
      TabOrder = 2
    end
    object edtQueue: TEdit
      Left = 18
      Top = 80
      Width = 482
      Height = 45
      TabOrder = 3
      TextHint = 'Enter Queue Name'
    end
    object Memo2: TMemo
      Left = 568
      Top = 135
      Width = 482
      Height = 146
      TabOrder = 4
    end
    object btnStop2: TButton
      Left = 689
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 5
      OnClick = btnStop2Click
    end
    object btnStart2: TButton
      Left = 568
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 6
      OnClick = btnStart2Click
    end
    object edtRoutingKey: TEdit
      Left = 791
      Top = 80
      Width = 259
      Height = 45
      TabOrder = 7
      TextHint = 'Enter RoutingKey'
    end
    object btnSend1: TButton
      Left = 395
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Send'
      TabOrder = 8
      OnClick = btnSend1Click
    end
    object edtExchange: TEdit
      Left = 568
      Top = 80
      Width = 217
      Height = 45
      TabOrder = 9
      TextHint = 'Enter Exchange'
    end
    object btnSend2: TButton
      Left = 945
      Top = 287
      Width = 105
      Height = 34
      Caption = 'Send'
      TabOrder = 10
      OnClick = btnSend2Click
    end
  end
end
