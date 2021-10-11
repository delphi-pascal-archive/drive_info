unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type

  TMainForm = class(TForm)
    btnGetDriveTypes: TButton;
    lbDrives: TListBox;
    lblSectPerClust2: TLabel;
    lblBytesPerSector2: TLabel;
    lblNumFreeClusters2: TLabel;
    lblTotalClusters2: TLabel;
    lblSectPerCluster: TLabel;
    lblBytesPerSector: TLabel;
    lblNumFreeClust: TLabel;
    lblTotalClusters: TLabel;
    lblFreeSpace2: TLabel;
    lblTotalDiskSpace2: TLabel;
    lblFreeSpace: TLabel;
    lblTotalDiskSpace: TLabel;
    procedure btnGetDriveTypesClick(Sender: TObject);
    procedure lbDrivesClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.btnGetDriveTypesClick(Sender: TObject);
var
  i: Integer;
  C: String;
  DType: Integer;
  DriveString: String;
begin
 lbDrives.Clear;
 // Loop from A..Z to determine available drives
 for i:=65 to 90 do
  begin
   // Format a string to represent the root directory.
   C:=chr(i)+':\';
   // Call the GetDriveType() function which returns an integer
   // value representing one of the types shown in the case statement
   // below
   DType:=GetDriveType(PChar(C));
   // Based on the drive type returned, format a string to add to
   // the listbox displaying the various drive types.
   case DType of
     0: DriveString:=C+' Тип накопителя не может быть определен.';
     1: DriveString:=C+' Корневая директория не существует.';
     DRIVE_REMOVABLE: DriveString:=
        C+' Диск может быть удален из накопителя.';
     DRIVE_FIXED: DriveString:=
        C+' Диск НЕ может быть удален из накопителя.';
     DRIVE_REMOTE: DriveString:=
        C+' Удаленный (сетевой) диск.';
     DRIVE_CDROM: DriveString:=C+' Устройство - CD-ROM.';
     DRIVE_RAMDISK: DriveString:=C+' Устройство - RAM диск.';
    end;
   // Only add drive types that can be determined.
   if not ((DType = 0) or (DType = 1))
   then lbDrives.Items.AddObject(DriveString, Pointer(i));
  end;
end;

procedure TMainForm.lbDrivesClick(Sender: TObject);
var
 RootPath: String;         // Holds the drive root path
 SectorsPerCluster: DWord; // Sectors per cluster
 BytesPerSector: DWord;    // Bytes per sector
 NumFreeClusters: DWord;   // Number of free clusters
 TotalClusters: DWord;     // Total clusters
 DriveByte: Byte;          // Drive byte value
 FreeSpace: Int64;         // Free space on drive
 TotalSpace: Int64;        // Total drive space.
begin
 with lbDrives do
  begin
    { Convert the ascii value for the drive letter to a valid drive number:
        1 = A, 2 = B, etc. by subtracting 64 from the ascii value. }
    DriveByte:=Integer(Items.Objects[ItemIndex])-64;
    // First create the root path string
    RootPath:=chr(Integer(Items.Objects[ItemIndex]))+':\';
    // Call GetDiskFreeSpace to obtain the drive information
    if GetDiskFreeSpace(PChar(RootPath), SectorsPerCluster,
      BytesPerSector, NumFreeClusters, TotalClusters)
    then
     begin
      // If this function is successful, then update the labels
      // to display the disk information
      lblSectPerCluster.Caption:=Format('%.0n', [SectorsPerCluster*1.0]);
      lblBytesPerSector.Caption:=Format('%.0n', [BytesPerSector*1.0]);
      lblNumFreeClust.Caption:=Format('%.0n', [NumFreeClusters*1.0]);
      lblTotalClusters.Caption:=Format('%.0n', [TotalClusters*1.0]);
      // Obtain the available disk space
      FreeSpace:=DiskFree(DriveByte);
      TotalSpace:=DiskSize(DriveByte);
      lblFreeSpace.Caption:=Format('%.0n', [FreeSpace*1.0]);
      // Calculate the total disk space
      lblTotalDiskSpace.Caption:=Format('%.0n', [TotalSpace*1.0]);
     end
    else
     begin
      // Set labels to display nothing
      lblSectPerCluster.Caption:='X';
      lblBytesPerSector.Caption:='X';
      lblNumFreeClust.Caption:='X';
      lblTotalClusters.Caption:='X';
      lblFreeSpace.Caption:='X';
      lblTotalDiskSpace.Caption:='X';
      ShowMessage('Невозможно получить информацию о диске!');
    end;
  end;

end;

end.
