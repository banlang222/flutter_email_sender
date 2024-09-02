import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import List from '@ohos.util.List';
import { UIAbility, Want, common } from '@kit.AbilityKit';

/** FlutterEmailSenderPlugin **/
export default class FlutterEmailSenderPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private context: common.UIAbilityContext | null = null;

  constructor() {
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.context = binding.getAbility().context;
    console.debug('flutter email sender attached to ability');
  }

  onDetachedFromAbility(): void {
  }

  getUniqueClassName(): string {
    return "FlutterEmailSenderPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_email_sender");
    this.channel.setMethodCallHandler(this)
    console.debug('flutter email sender attached to engine');
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    console.debug(`flutter email sender got a call : ${call.method}`);
    if (call.method == "send") {
      let body: string = call.argument('body');
      let isHtml: boolean = call.argument('is_html');
      let subject: string = call.argument('subject');
      let recipients: List<string> = call.argument('recipients') || new List();
      let cc: List<string> = call.argument('cc') || new List();
      let bcc: List<string> = call.argument('bcc') || new List();
      let attachment_paths: List<string> = call.argument('attachment_paths') || new List();
      console.debug(`recipients=${recipients}, cc=${cc}, bcc=${bcc}, attachment_paths=${attachment_paths}`);

      let wantParams : Record<string, Object> = {
        'sceneType': 1,
        'email': recipients,
        'cc': cc,
        'bcc': bcc,
        'subject': encodeURI(subject),
        'body': encodeURI(body),
        // 'ability.params.stream': [],
        // 'ability.want.params.uriPermissionFlag':1
      };

      console.debug(`wantParams: ${JSON.stringify(wantParams)}`);

      let abilityStartCallback: common.AbilityStartCallback = {
        onError: (code: number, name: string, message: string)=>{
          console.debug(`ability start call back error : code:` + code + `name:` + name + `message:` + message);

        }, onResult: (startResult)=>{
          console.debug(`ability start call back result: ${JSON.stringify(startResult)}`);
          if(startResult.resultCode == 401) {
            result.error('401', '没有可拉起的应用', null);
          } else {
            result.success('mail send success');
          }
        }
      }

      this.context?.startAbilityByType('mail', wantParams, abilityStartCallback, (err)=>{
        if(err){
          console.error(`startAbilityByType failed, error:${JSON.stringify(err)}`);
          result.error('send mail error', JSON.stringify(err), null);
        }
      });

    } else {
      result.notImplemented()
    }
  }
}