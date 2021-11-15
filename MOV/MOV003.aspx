<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MOV003.aspx.cs" Inherits="MOV_MOV003" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="player/mediaplayer.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="player/mediaplayer.js"></script>

    <script type="text/javascript">
        _V_.options.flash.swf = "player/mediaplayer.swf";
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>供應商資料變更作業教學
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">供應商資料變更作業教學</li>
            </ol>
        </section>
        <!-- Main content -->
        <section class="content">
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                        </div>
                        <div class="box-body">
                            <video id="video_containter" class="video-js vjs-default-skin" controls preload="none" width="100%" height="600" poster="" data-setup="{}">
                                <source src="MOV003.mp4" type="video/mp4" />
                                <!--
		<track kind="captions" src="" srclang="en_US" label="English (U.S.)" />
		-->
                            </video>

                            <div id="video_alt">You need <a href="http://get.adobe.com/flashplayer">Flash Player</a> to view this video.</div>

                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
        </section>
        <!-- /.content -->
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="Server">
    <script type="text/javascript">
        //remove alternative content when player ready
        _V_("video_containter").ready(function () {
            var element = document.getElementById("video_alt");
            element.parentNode.removeChild(element);
        });
    </script>

</asp:Content>

