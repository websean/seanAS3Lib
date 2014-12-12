/********************************************************************************************
   KeyManager

   Author:			Keith Hair
   Date:			Feburary-13-2010
   Email:			khos2007@gmail.com
   Website:			http://keith-hair.net
   Version:			1.0.0.1
   License:			Creative Commons http://creativecommons.org/licenses/by/3.0/
   Description:
   A class for setting functions to execute for assigned key combinations or key sequences.

   Example:

   //------------------------------------------------------------------------------------------------------
   //Define a KeyManager instance, giving it a stage to for the class to assign KeyboardEvent listeners to.
   //------------------------------------------------------------------------------------------------------
   var keyManager:KeyManager=new KeyManager(stage);

   //---------------------------------------------------------
   //Sets up control where the shift key and right arrow key must be pressed together to execute "goRight"
   //"stopRight" will execute when this key combination is no longer pressed.
   //----------------------------------------------------------
   keyManager.addKey(["shift","right"], goRight,stopRight);

   //----------------------------------------------------------------
   //"openEasterEgg" will execute wil all of the keys in the Array are pressed in sequence.
   //-----------------------------------------------------------------
   keyManager.addKeySequence(["up","up","down","down","left","right","left","right"],openEasterEgg);


   Note 1:
   I recommend you use the keycode constants of the Keyboard class, although
   the "addKey" method will attempt a lexical match to the relevant keycode.
   For example, "1" key is different from "Number Pad 1" key.

   Note 2:
   For Flash AS3 only projects, it best to use main "stage" as the host parameter in KeyManager constructor.
   If using in Flex, I recommend using "Application.application.systemManager.stage" has the host parameter.
 **********************************************************************************************/
package sean.lib
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class KeyManager extends EventDispatcher
	{
		private var _host:IEventDispatcher;
		private var _keys:Object={};
		private var _pressed:Object={};
		private var _seq:Array=[];
		private var _seqlimit:int=0;
		private var _seqstr:String="";
		private var _hasseq:Boolean=false;

		/**
		 *@param This is an Object that implements IEventDispatcher.
		 *"host" is an object that KeyboardEvent listeners will be automatically added to.
		 *If this is left null, the "host" will default to "Application.application.systemManager.stage".
		 **/
		public function KeyManager(host:IEventDispatcher=null)
		{
			_host=host;
			addListeners();
		}

		/**
		 * @param keycombo The combination of keys as an Array. If key in the keycombo is a String, this method will attempt to find the lexical keycode match, but it is recommnded you use strict keycodes from the Keyboard class constants.
		 * @param startFunc The start Function to execute when all of the keys in the keycombo Array are pressed.
		 * @param endFunc The end Function to execute when the current key combination is no longer complete.
		 * @param id A String to make storage of each key combination unique. If an "id" is not given, the id will automatically be set to the current number of keycombos added with addKey.
		 * @param singular If true, this keycombo will cancel execution of other keycombos and execute alone. If false, this keycombo will execute along with other keycombo's pressed.
		 * @return true if the key id has not been added before, false if the id is already added.
		 *
		 * Note: String entrie are case insensitive.
		 **/
		public function addKey(keycombo:Array, startFunc:Function=null, endFunc:Function=null, id:String="", singular:Boolean=true):Boolean
		{
			//-----------------------------------------------------------------------------------
			//formatKeyArray will find the lexical keycode match of each in the key combination.
			//-----------------------------------------------------------------------------------
			var a:Array=formatKeyArray(keycombo);
			//-------------------------------------------
			//Set default unique id if one is not given.
			//-------------------------------------------
			id=id || getTotalKeys().toString();
			//-----------------------------------
			//Prevent same key id from being adding 
			//----------------------------------
			if (getKeyByID(id) != null)
			{
				return false;
			}
			_keys[id]={keys: a, startfunc: startFunc, endfunc: endFunc, id: id, singular: singular};
			return true;
		}

		/**
		 *
		 * @param	keyseq The sequence of keys to press to execute the given Function in "func".
		 * @param	func The function to execute a sequence of key presses match "keyseq"
		 * @param	id A String to make storage of each key combination unique. If an "id" is not given, the id will automatically be set to the current number of keycombos added with addKeySequence.
		 * @return true if the key id has not been added before, false if the id is already added.
		 */
		public function addKeySequence(keyseq:Array, func:Function=null, id:String=""):Boolean
		{
			//-----------------------------------------------------------------------------------
			//formatKeyArray will find the lexical keycode match of each in the key in the sequence.
			//-----------------------------------------------------------------------------------			
			var a:Array=formatKeyArray(keyseq);
			//-------------------------------------------
			//Set default unique id if one is not given.
			//-------------------------------------------
			id=id || getTotalKeys().toString();
			//-----------------------------------
			//Prevent same key id from being adding 
			//----------------------------------
			if (getKeyByID(id) != null)
			{
				return false;
			}
			_hasseq=true;
			_seqlimit=Math.max(_seqlimit, a.length);
			_keys[id]={keys: a, startfunc: func, id: id, isSeq: true};
			return true;
		}

		/**
		 * @param The id used in add the key combination with "addKey".
		 * @return True if the id existed and was removed. False, if the id does not exist.
		 **/
		public function removeKey(id:String):Boolean
		{
			if (getKeyByID(id) == null)
			{
				return false;
			}
			delete _keys[id];
			var ko:Object;
			var i:int=0;
			for each (ko in _keys)
			{
				if (ko.isSeq)
				{
					i++;
					break;
				}
			}
			_hasseq=i > 0;
			return true;
		}

		/**
		 *Clears all key combination added with "addKey".
		 **/
		public function removeAllKeys():void
		{
			_keys={};
			_seqlimit=0;
		}

		/**
		 *This is the disposal method that should be called before clearing references to this class's instances.
		 **/
		public function remove():void
		{
			removeAllKeys();
			processKeysUp();
			removeListeners();
			_pressed={};
			_seq=[]
			_host=null;
			_hasseq=false;
			_seqstr="";
		}

		/**
		 * @param The String used to name a key combination with "addKey"
		 * @return An Object containing the given id.
		 **/
		private function getKeyByID(id:String):Object
		{
			return _keys[id];
		}

		private function __onKeyDown(evt:KeyboardEvent):void
		{
			var k:int=evt.keyCode;
			if (k >= 97 && k <= 122)
			{
				k=String.fromCharCode(k).toUpperCase().charCodeAt(0);
			}
			_pressed[k]=true;
			if (_hasseq)
			{
				_seq.push(k);
				_seqstr=_seq.toString();
				//-------------------------------------------------------------------------
				//Shave off beginning element each time number of key presses grow larger
				//length of largest sequence...helps conserve memory.
				//-------------------------------------------------------------------------
				if (_seq.length > _seqlimit)
				{
					_seq.shift();
				}
			}
			processKeysDown();
		}

		private function __onKeyUp(evt:KeyboardEvent):void
		{
			delete _pressed[evt.keyCode];
			processKeysUp();
		}

		private function addListeners():void
		{
			removeListeners();
			_host.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			_host.addEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
		}

		private function removeListeners():void
		{
			_host.removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			_host.removeEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
		}

		private function processKeysDown(ignoreExec:Boolean=false, isUp:Boolean=false):void
		{
			var ko:Object;
			var n:int;
			var cnt:int=0;
			var i:int;
			for each (ko in _keys)
			{
				//------------------------------------------------
				//If key combo is active already, skip iteration.
				//------------------------------------------------
				if (ko.executed && !ignoreExec)
				{
					continue;
				}
				cnt=0;
				n=ko.keys.length;
				while (n > -1)
				{
					//----------------------------------------------
					//If a key is found in _pressed object count it.
					//----------------------------------------------
					if (_pressed[ko.keys[n]])
					{
						cnt++;
					}
					n--;
				}
				//------------------------------------------------------
				//Detect if all keys in combo is pressed and mark it active.
				//------------------------------------------------------ 
				if (cnt == ko.keys.length)
				{
					if (ko.singular)
					{
						cropToCombo(ko);
					}
					if (ko.startfunc != null && !ko.isSeq)
					{
						ko.executed=true;
						ko.startfunc();
					}
				}
				//------------------------------------------------------
				//Detect key sequence, and execute if found.
				//------------------------------------------------------ 				
				if (ko.isSeq)
				{
					if (checkSequence(ko.keys) && !isUp)
					{
						if (ko.startfunc != null)
						{
							ko.startfunc();
						}
						_seq=[];
					}
				}
			}
		}

		private function processKeysUp():void
		{
			var ko:Object;
			var n:int;
			var cnt:int=0;
			var missing:Boolean;
			for each (ko in _keys)
			{
				missing=false;
				n=ko.keys.length - 1;
				while (n > -1)
				{
					if (_pressed[ko.keys[n]] == null && ko.executed && !ko.isSeq)
					{
						ko.executed=null;
						if (ko.endfunc != null)
						{
							ko.endfunc();
						}
						break;
					}
					n--;
				}
			}
			processKeysDown(true, true);
		}

		private function cropToCombo(keyobj:Object):void
		{
			var ko:Object;
			var n:int;
			keyobj.executed=null;
			for each (ko in _keys)
			{
				if (ko.id != keyobj.id)
				{
					if (ko.endfunc != null && ko.executed)
					{
						ko.endfunc();
					}
				}
			}
		}

		private function checkSequence(a:Array):Boolean
		{
			if (_seqstr.indexOf(a.toString()) != -1)
			{
				return true;
			}
			return false;
		}

		private function formatKeyArray(a:Array):Array
		{
			var n:int=a.length - 1;
			while (n > -1)
			{
				a[n]=findKey(a[n]);
				n--;
			}
			return a.slice();
		}

		private function getTotalKeys():int
		{
			var c:int=0;
			var ko:Object;
			for each (ko in _keys)
			{
				c++;
			}
			return c;
		}

		private function findKey(key:Object):int
		{
			var s:String;
			var code:int;
			if (key is String)
			{
				s=String(key).toUpperCase();
				if (s.length > 1)
				{
					code=Keyboard[s];
				}
				else
				{
					code=s.charCodeAt(0);
				}
				if (code == 0)
				{
					if (s.search(/num|pad/mig) != -1)
					{
						code=Keyboard["NUMPAD_" + s.replace(/\D+/mig, "")];
					}
				}
			}
			else
			{
				code=key as int;
			}
			return code;
		}
	}
}