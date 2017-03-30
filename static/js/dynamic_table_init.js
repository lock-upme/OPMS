$(document).ready(function() {

    $('#dynamic-table').dataTable( {
    	"bPaginate": false,
    	"bFilter": false,
    	"bInfo": false,
"sInfoEmpty":"无",
"sZeroRecords": "没有检索到数据", 
        "aaSorting": [[ 4, "desc" ]]
    } );

   
} );