package grandtech{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	import mx.states.State;
	import mx.states.Transition;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Panel;
	import spark.components.TextArea;
	import spark.components.VideoDisplay;
	import spark.components.VideoPlayer;
	import spark.components.WindowedApplication;
	import spark.layouts.BasicLayout;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.TileLayout;
	import spark.layouts.VerticalLayout;
	
	import test.test1;
	
	public class Main extends WindowedApplication{
		
		var nc1:NetConnection;
		var v1:VideoDisplay;
		var listPanel,tilePanel,moviePanel:Panel;
		var leftGroup,rightGroup,panelGroup,controlGroup,outerGroup:Group;
		
		var btnSwitchLayout,btnSwitchLayout2,btnGetWS:Button;
		var textbox:TextArea;
		var dg:DataGrid;
		var ws:WebService;
		
		public function Main() {
			addEventListener(FlexEvent.CREATION_COMPLETE, H_CreationComplete); 
		}	
		
		public function H_CreationComplete(event : FlexEvent ):void	{
			//trace("stage:"+stage);
			//stage.addEventListener(Event.RESIZE, stage_onResize);
			initUI();		
		}
		
		public function stage_onResize(event : FlexEvent):void {
			trace("resize!");
			
		}
		
		public function initUI():void
		{
			this.width = 1024;
			this.height = 768;			
			
			var vlt:VerticalLayout = new VerticalLayout();
			vlt.gap = 1;
			outerGroup = new Group();
			outerGroup.layout = vlt;
			
			initListPanel();
			initTilePanel();
			initMoviePanel();
			
			initLeftGroup();
			initRightGroup();
			
			initPanelGroup();
			initControlGroup();
			
			var vd1:VideoDisplay = getNonSkinableVideoPlayer();
			vd1.width = this.width;
			vd1.height = this.height;
			vd1.play();
			addElement(vd1);
			addElement(outerGroup);
		}
		
		public function initListPanel():void{
			listPanel = new Panel();
			listPanel.title = "list window";
			
			dg = new DataGrid();
			var columns:Array = new Array();

			var dgc1:DataGridColumn = new DataGridColumn("users_login_name");
			var dgc2:DataGridColumn = new DataGridColumn("users_password");
			dgc1.headerText = "ID";
			dgc2.headerText = "Password";			
			dgc1.width = dgc2.width = this.width/4;
			columns.push(dgc1);
			columns.push(dgc2);
			dg.columns = columns;
			
			listPanel.addElement(dg);
		}
		
		public function initTilePanel():void{
			tilePanel = new Panel();
			tilePanel.title = "tile window";
			tilePanel.layout = new TileLayout();
			tilePanel.addElement(newImage());
			tilePanel.addElement(newImage());
			tilePanel.addElement(newImage());
			tilePanel.addElement(newImage());
			tilePanel.addElement(newImage());
			tilePanel.addElement(newImage());
		}
		
		public function initMoviePanel():void{
			moviePanel = new Panel();
			moviePanel.title = "movies here!";
			moviePanel.addElement(getSkinableVideoPlayer());
		}

		public function initControlGroup():void{
			controlGroup = new Group();
			controlGroup.layout = new HorizontalLayout();
			controlGroup.height = 21;
			btnSwitchLayout = new Button();
			btnSwitchLayout.label = "switch layout";
			btnSwitchLayout.addEventListener(MouseEvent.CLICK, H_btnSwitchLayout_onClick);
			controlGroup.addElement(btnSwitchLayout);
			
			btnSwitchLayout2 = new Button();
			btnSwitchLayout2.label = "switch layout2";
			btnSwitchLayout2.addEventListener(MouseEvent.CLICK, H_btnSwitchLayout2_onClick);
			controlGroup.addElement(btnSwitchLayout2);
			
			btnGetWS = new Button();
			btnGetWS.label = "load user list webservice";
			btnGetWS.addEventListener(MouseEvent.CLICK, H_btnGetWS_onClick);
			controlGroup.addElement(btnGetWS);
			
			outerGroup.addElement(controlGroup);
		}
		public function H_btnSwitchLayout_onClick(event:Event):void
		{
		}
		public function H_btnSwitchLayout2_onClick(event:Event):void
		{
			
		}
		
		public function H_btnGetWS_onClick(event:Event):void
		{
			useWebService();
		}
		
		public function useWebService():void { 
			ws = new WebService(); 
			ws.wsdl="http://192.168.0.232:8500/mbs_content/scripts/sec_component.cfc?wsdl"; 
			ws.sec_get_users_list.addEventListener("result", ws_onResult); 
			ws.addEventListener("fault", ws_onError); 
			ws.loadWSDL(); 
			ws.sec_get_users_list(null,null,"users_login_name,users_password"); 
		} 
		
		public function ws_onResult(event:ResultEvent):void { 
			trace("echoResultHandler"+event.result.result);
			dg.dataProvider = event.result.result.row;
		} 
		
		public function ws_onError(event:FaultEvent):void { 
			//deal with event.fault.faultString, etc 
			trace("error:"+ event.fault.faultString);
		} 
		public function initPanelGroup():void{
			panelGroup = new Group();
			panelGroup.layout = new HorizontalLayout();
			panelGroup.addElement(leftGroup);
			panelGroup.addElement(rightGroup);
			outerGroup.addElement(panelGroup);
		}
		
		public function initLeftGroup():void{
			leftGroup = new Group();
			leftGroup.width = this.width/2;
			leftGroup.x = 0;
			leftGroup.y = 0;
			leftGroup.layout = new VerticalLayout();
			leftGroup.addElement(tilePanel);
			leftGroup.addElement(listPanel);
		}
		
		public function initRightGroup():void{
			rightGroup = new Group();			
			rightGroup.width = this.width/2;
			rightGroup.y = 0;
			rightGroup.x = leftGroup.x + leftGroup.width;
			rightGroup.layout = new BasicLayout();
			rightGroup.addElement(moviePanel);			
		}
		
		public function getSkinableVideoPlayer():VideoPlayer {
			var vp:VideoPlayer = new VideoPlayer();
			vp.source = "rtmp://202.134.125.201/vod/sample";
			vp.autoPlay = false;
			vp.scaleMode = "stretch";
			return vp;
		}
		
		public function getNonSkinableVideoPlayer():VideoDisplay {
			var vp:VideoDisplay = new VideoDisplay();
			vp.source = "rtmp://localhost/vod/mp4:sample1_150kbps.f4v";
			vp.scaleMode = "stretch";
			vp.loop = true;
			vp.autoPlay = true;
			return vp;
		}
				
		public function addPureVideo()
		{
			nc1 = new NetConnection();
			nc1.client = {};
			nc1.client.onBWDone = function ():void {};
			nc1.addEventListener(NetStatusEvent.NET_STATUS, H_netStatus); 
			nc1.connect("rtmp://localhost/vod");
		}
		
		public function H_netStatus(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found: ");
					break;
			}		
		}
		public function connectStream()
		{
			//use non-skinable video component
			var stream:NetStream = new NetStream(nc1);
			stream.client = {};
			stream.client.onMetaData = function ():void {};
			var vdo1:Video = new Video();
		}
		
		public function newImage():Image
		{
			var img:Image = new Image();
			img.source = "C:\\Users\\Ferry.To\\Desktop\\cars\\Aston_Martin-DB9_2004_thumbnail_03.jpg";
			return img;
		}
	}

}