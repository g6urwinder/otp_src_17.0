%%  coding: latin-1
%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: CosFileTransfer_FileList
%% Source: /net/isildur/ldisk/daily_build/17_prebuild_master-opu_o.2014-04-07_20/otp_src_17/lib/cosFileTransfer/src/CosFileTransfer.idl
%% IC vsn: 4.3.5
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module('CosFileTransfer_FileList').
-ic_compiled("4_3_5").


-include("CosFileTransfer.hrl").

-export([tc/0,id/0,name/0]).



%% returns type code
tc() -> {tk_sequence,
            {tk_struct,"IDL:omg.org/CosFileTransfer/FileWrapper:1.0",
                "FileWrapper",
                [{"the_file",
                  {tk_objref,"IDL:omg.org/CosFileTransfer/File:1.0","File"}},
                 {"file_type",
                  {tk_enum,"IDL:omg.org/CosFileTransfer/FileType:1.0",
                      "FileType",
                      ["nfile","ndirectory"]}}]},
            0}.

%% returns id
id() -> "IDL:omg.org/CosFileTransfer/FileList:1.0".

%% returns name
name() -> "CosFileTransfer_FileList".



