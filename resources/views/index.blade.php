<!DOCTYPE html>
<html lang="en">

<head>
    @include('layouts.userHead')
</head>

<body>
    @include('layouts.userNavbar')
    <!-- Page Content -->
    <div class="container">
        <!-- Jumbotron Header -->
        <header class="jumbotron hero-spacer">
            <div style="text-align:center;">
                <a href="http://time.is/Surabaya" id="time_is_link" rel="nofollow" style="font-size:64px"></a>
                <span id="Surabaya_z41c" style="font-size:72px"></span>
                <script src="http://widget.time.is/id.js"></script>
                <script>
                time_is_widget.init({Surabaya_z41c:{template:"TIME<br>DATE", date_format:"dayname, dnum monthname year"}});
                </script>
            </div>
        </header>
        <hr>
        <div  id="marquee" direction="up" style="font-size:44px;text-align: center;margin:auto;">
                <ul style="width:100%; font-weight:bold;">
                @foreach($pengumuman as $tulisan)
                    <li>{{$tulisan->info_info}}</li>
                @endforeach
                </ul>
        </div>
        <!-- Footer -->
        @include('layouts.footer')
    </div>
    <!-- /.container -->

    <!-- jQuery -->
    <script src="{{ URL::asset('js/jquery.js') }}"></script>

    <!-- Bootstrap Core JavaScript -->
	<link href="../js/bootstrap.min.js">
	<link href="../js/jquery.vticker.min.js">
    <script src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/jquery.vticker.min.js"></script>
    <script type="text/javascript">
        $(function() {
            $('#marquee').vTicker();
        });
    </script>
</body>

</html>
