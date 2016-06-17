package sinais.powermeter.handlersObjects
{
	public  class XML_Handlers
	{
		public static const   xmlDummy:XML=<powerSample pA="0" timestamp="0"></powerSample>;
		

		public function XML_Handlers(){
		
		}
		
		public function buildHourXML(xmlfile:XML):Array{
		
				trace("building hour xml");
				var j:int=4;
				var i:int=0;
				
				var length:int = calculatesXMLSize(xmlfile);
				var test:Number=0;
				var returnXML:XML=xmlfile;
				var data:Date;
				
				var returnResult:Array = new Array(0,0,0,0,0,0,0,0,0,0,0,0);
				for(i=0;i<length;i++){
				test = Number(new Date(xmlfile.powerSample[i].@timestamp).minutes);
							 
						if (test<=5)
							returnResult[0]=xmlfile.powerSample[i].@pA;
							
						else if( (test > 5) && (test<=10))
							returnResult[1]=xmlfile.powerSample[i].@pA;
							
						else if( (test > 10) && (test<=15))
							returnResult[2]=xmlfile.powerSample[i].@pA;
							
						else if( (test >15) && (test<=20))
							returnResult[3]=xmlfile.powerSample[i].@pA;
							
						else if( (test>20) && (test<=25))
							returnResult[4]=xmlfile.powerSample[i].@pA;
							
						else if( (test>25) && (test<=30))
							returnResult[5]=xmlfile.powerSample[i].@pA;
							
						else if( (test>30) && (test<=35))
							returnResult[6]=xmlfile.powerSample[i].@pA;
							
						else if( (test>35) && (test<=40))
							returnResult[7]=xmlfile.powerSample[i].@pA;
							
						else if( (test>40) && (test<=45))
							returnResult[8]=xmlfile.powerSample[i].@pA;
							
						else if( (test>45) && (test<=50))
							returnResult[9]=xmlfile.powerSample[i].@pA;
							
						else if( (test>50) && (test<=55))
							returnResult[10]=xmlfile.powerSample[i].@pA;
							
						else if( (test>55) && (test<=60))
							returnResult[11]=xmlfile.powerSample[i].@pA;
				}
				
				
			return returnResult;
		}
		
		public function buildWeekXML(xmlfile:XML):XML{
			
			var i:int=1;
			var j:int;
			var length:int = calculatesXMLSize(xmlfile);
			var returnXML:XML=xmlfile;
			var ts:int=0;
			var data:Date;					
			
			while(i<length){
				
				data	= new Date(returnXML.powerSample[i-1].@timestamp);		
				if(data.dayUTC==i){
					//trace(data.dayUTC);
				}
				
				if(data.dayUTC>i){
					while(data.dayUTC>i){	
						//trace(data.dayUTC);
						xmlfile.insertChildBefore(xmlfile.powerSample[i-1],xmlDummy);
						length++;
						i++;
					}
				}
				if(data.dayUTC==0){			
					//	trace(data.dayUTC);
					xmlfile.insertChildBefore(xmlfile.powerSample[i-1],xmlDummy);
					length++;
				}
				i++;
			}
			
			var xmlDumm:XML=<powerSample pA="0" timestamp="0"></powerSample>;							
			i =	calculatesXMLSize(xmlfile);			
			
			while(calculatesXMLSize(xmlfile)<7){
				
				xmlfile.appendChild(xmlDumm);
				
			}
			return xmlfile;
			
		}
		
		public  function buildDayXML(xmlfile:XML):XML{
			trace("building daily xml");
			var j:int;
			var i:int=0;
			
			var length:int = calculatesXMLSize(xmlfile);
			
			var returnXML:XML=xmlfile;
			var ts:int=0;
			var data:Date;
			
			
			while(i<length){
				
				data	= new Date(returnXML.powerSample[i].@timestamp);
				
				if(data.hours==i){
					
				}
				
				if(data.hours>i){
					
					while(data.hours>i){
						xmlfile.insertChildBefore(xmlfile.powerSample[i],xmlDummy);
						length++;
						i++;
					}
					
				}
				i++;
			}
			
			var xmlDumm:XML=<powerSample pA="0" timestamp="0"></powerSample>;				
			
			i =	calculatesXMLSize(xmlfile);
			
			while(calculatesXMLSize(xmlfile)!=24){
				
				xmlfile.appendChild(xmlDumm);
				
			}
			
			return xmlfile;
			
		}
		
		
		public function buildMonthXML(xmlfile:XML):XML{
		trace('building monthly XML');	
				var j:int;
		var i:int=1;
		
		var length:int = calculatesXMLSize(xmlfile);
		
		var returnXML:XML=xmlfile;
		var ts:int=1;
		var data:Date;
		
		
		while(i<=length){
			
			data	= new Date(returnXML.powerSample[i-1].@timestamp);
			
			if(data.date==i){
				
			}
			
			if(data.dateUTC>i){
				
				while(data.dateUTC>i){
					xmlfile.insertChildBefore(xmlfile.powerSample[i-1],xmlDummy);
					length++;
					i++;
				}
				
			}
			i++;
		}
		
		
		i =	calculatesXMLSize(xmlfile);
		var xmlDumm:XML=<powerSample pA="0" timestamp="0"></powerSample>;				
		while(calculatesXMLSize(xmlfile)!=31){
			
			xmlfile.appendChild(xmlDumm);
			
		}
		
		return xmlfile;
		
		}
		
		public  function buildYearXML(xmlfile:XML):XML{
			trace("building year xml");
			var j:int;
			var i:int=0;
			
			var length:int = calculatesXMLSize(xmlfile);
			
			var returnXML:XML=xmlfile;
			var ts:int=0;
			var data:Date;
			
			
			while(i<length){
				
				data	= new Date(returnXML.powerSample[i].@timestamp);
				
				if(data.month==i){
					
				}
				
				if(data.month>i){
					
					while(data.month>i){
						xmlfile.insertChildBefore(xmlfile.powerSample[i],xmlDummy);
						length++;
						i++;
					}
					
				}
				i++;
			}
			
			var xmlDumm:XML=<powerSample pA="0" timestamp="0"></powerSample>;				
			
			i =	calculatesXMLSize(xmlfile);
			
			while(calculatesXMLSize(xmlfile)!=12){
				
				xmlfile.appendChild(xmlDumm);
				
			}
			
			return xmlfile;
			
		}
		
		public  function calculatesXMLSize(xmlfile:XML):int{
		
			var i:int=0;
			if(xmlfile!=null){
				while(xmlfile.powerSample[i]!=null){
					i++;
				}	
				return i;
			}
				else return 0;

			
		}		
		
		public  function calculatesXMLSizeG(xmlfile:XML):int{
			
			var i:int=0;
			if(xmlfile!=null){
				while(xmlfile.goalSample[i]!=null){
					i++;
				}	
				return i;
			}
			else return 0;
			
			
		}	

	}
}