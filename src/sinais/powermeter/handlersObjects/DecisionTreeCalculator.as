package sinais.powermeter.handlersObjects {
	
	public  class DecisionTreeCalculator {
		
		public function DecisionTreeCalculator() {
		}
		
		public static function getCluster(lrAlphaP:Number,lrBetaP:Number,deltaPMean:Number):Array {
		
			var result:Array = new Array;
			
			if(deltaPMean>400){
				result.push(1);
				result.push(getClusterPositive(lrAlphaP,lrBetaP));
			}
			if(deltaPMean<-400){
				result.push(2);
				result.push(getClusterNegative(lrAlphaP,lrBetaP));
			}
			if(deltaPMean>75 && deltaPMean<=400){
				result.push(3);
				result.push(getCluster75400(lrAlphaP,lrBetaP));
			}
			if(deltaPMean<-75 && deltaPMean>=-400){
				result.push(4);
				result.push(getCluster_70_400(lrAlphaP,lrBetaP));
			}
			
			return result;
		}
		
		public static function getClusterPositive(lrAlphaP:Number, lrBetaP:Number):int{
			
			var clusterResult:int=0;
			
			
			if(lrAlphaP<=9.945){
			
				if(lrBetaP<=0.015){
					
					if(lrAlphaP<=5.086){
						clusterResult = 3;	
					}
					else{
						clusterResult = 5;
					}
					
				}
				else{
					if(lrBetaP<=0.025){
						
						if(lrAlphaP<=5.323){
								clusterResult = 3;
						}
						else{
								clusterResult = 2;
						}
					}
					else{
						clusterResult = 1;	
					}
				}
				
			}
			else{
			
				if(lrBetaP<=0.015){
					clusterResult = 4;	
				}
				else{
					clusterResult = 2;
				}
					
				}
			return clusterResult;

			}
		
		public static function getClusterNegative(lrAlphaP:Number, lrBetaP:Number):int{
			var clusterResult:int = 0;
			
			if(lrBetaP<=-0.015){
				
				if(lrBetaP<=-0.025){
					
					if(lrAlphaP<=28.135){
						clusterResult = 11;
					}
					else{
						clusterResult = 10;
					}
				}
				else{
					if(lrAlphaP<=27.673){
						clusterResult = 9;
					}
					else{
						clusterResult = 10; 
					}
				}
			}
			else{
				
				if(lrAlphaP<=25.435){
				
					if(lrAlphaP<=21.766){
						clusterResult = 7;
					}
					else{
						clusterResult = 10;
					}
				}
				else{
				
					if(lrAlphaP<=30.607){
						clusterResult = 10;
					}
					else{
						clusterResult = 8;
					}
				}
			
			}
			
			return clusterResult;

		}
		
		public static function getCluster75400(lrAlphaP:Number, lrBetaP:Number):int{
			
			var clusterResult:int=0;
			
			if(lrBetaP<=0.085){
				if(lrAlphaP<=10.114){
					if(lrAlphaP<=4.042){
						clusterResult=13;
					}
					else{
						clusterResult=14;
					}
				}
				else{
					clusterResult=15;
				}
			}
			else{
				if(lrAlphaP<=1.788){
					if(lrBetaP<=0.105){
						clusterResult=13;
					}
					else{
						if(lrAlphaP<=-0.773){
							if(lrBetaP<=0.125){
								clusterResult=13;
							}
							else{
								clusterResult=12;
							}
							
						}
						else{
							if(lrBetaP<=0.115){
								if(lrAlphaP<=0.548){
									clusterResult=13;
								}
								else{
									clusterResult=12;
								}
							}
							else{
								clusterResult=12;
							}
						}
					
					}
				}
				else{
					if(lrBetaP<=0.095){
						if(lrAlphaP<=6.954){
							if(lrAlphaP<=3.028){
								clusterResult=13;
							}
							else{
								clusterResult=12;
							}
						}
						else{
							clusterResult=14;
						}
					}
					else{
						clusterResult=12;
					}
				}
			
			}
		
		
		return clusterResult;
		}
		
		public static function getCluster_70_400(lrAlphaP:Number, lrBetaP:Number):int{
		
			var clusterResult:int =0;
			if(lrBetaP<=0.105){
				if(lrAlphaP<=27.613){
					clusterResult = 18;
				}
				else{
					if(lrBetaP<=-0.145){
						if(lrAlphaP<=30.060){
							if(lrAlphaP<=29.046){
								clusterResult=18;
							}
							else{
								if(lrBetaP<=-0.155){
									clusterResult=18;
								}
								else{
									clusterResult=19;
								}
							}
						}
						else{
							if(lrBetaP<=-0.175){
								if(lrAlphaP<=30.980){
									clusterResult=18;
								}
								else{
									clusterResult=19;
								}
							}
							else{
								clusterResult=19;
							}
						}
					}
					else{
						if(lrAlphaP<=28.343){
							if(lrBetaP<=-0.135){
								clusterResult = 18;
							}
							else{
								clusterResult = 19;
							}
						}
						else{
							clusterResult = 19;
						}
					}
				
				}
			}
			else{
				if(lrAlphaP<=20.855){
					clusterResult = 16;
				}
				else{
					if(lrAlphaP<=26.821){
						if(lrBetaP<=-0.085){
							if(lrAlphaP<=25.695){
								clusterResult=17;
							}
							else{
								clusterResult=19;
							}
						}
					}
					else{
						if(lrBetaP<=-0.065){
							clusterResult=19;
						}
						else{
							if(lrAlphaP<=27.736){
								if(lrBetaP<=-0.055){
									if(lrAlphaP<=27.293){
										clusterResult=17;
									}
									else{
										clusterResult=19;
									}
								}
								else{
									clusterResult=17;
								}
							}
							else{
								if(lrAlphaP<=29.076){
									if(lrBetaP<=-0.035){
										clusterResult=19;
									}
									else{
										clusterResult=17;
									}
								}
								else{
									clusterResult=19;
								}
							}
						}
					}
				}
			
			}
			return clusterResult;
		}
			
	
	}
	
}