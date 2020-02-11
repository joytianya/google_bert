# coding=utf8
import codecs
import sys
import re
from nstools.zhtools.langconv import *
import emoji


emoji_regex = emoji.get_emoji_regexp()

human_list = ['▲top', '▲topoct', '▲topmay', '▲topapr', '▲topmar', '▲topjun', '▲topdec', '▲topnov', '▲topaug', '▲topjul', '▲topjan', '▲topsep', '▲topfeb', '￥799', '￥2899', '～～', '～～～', '##～6', '##～10', '～10', '##～5', '～5', '##～20', '##～8', '##～17', '##～1', '～4', '##～3', '##～7', '～1', 'ｗedding', '×email', 'ｃｐ', '××', 'ｏｋ','a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'ａ', 'ｂ', 'ｃ', 'ｄ', 'ｅ', 'ｆ', 'ｇ', 'ｈ', 'ｉ', 'ｊ', 'ｋ', 'ｌ', 'ｍ', 'ｎ', 'ｏ', 'ｐ', 'ｑ', 'ｒ', 'ｓ', 'ｔ', 'ｕ', 'ｖ', 'ｗ', 'ｘ', 'ｙ', 'ｚ', '##★', '##℃', '##～', '##°', '##☆', '↓↓↓', '##●', '##㎡', '##♪', '##×', '▌♥', '##｜', '##ｄ', '##▲', '##ｏ', '★★', '##→', '#ａ', '⋯⋯', '##▼', '##○', '★★★★★', '##∥', '##◆', '##ω', '★★★', '##ｃ', '##ｓ', '##ｅ', '##ｐ', '##■', '##↑', '##ｋ', '##и', '◆◆', '##ｇ', '##＋', '##а', '±0', '##◎', '##─', '##ｒ', '##＞', '##²', '##ｔ', '★★★★', '##│', '##ｎ', '##ｌ', '##＝', '##ｙ', '☆☆☆', '##ｉ', '##↓', 'ˋ▽ˊ', '##ｖ', '↓↓', '##f2016', '##ｑ', '##₂', '∟∣', '##я', '##←', '##◆◆', '##ｘ', '##cm～', '##ｆ', '##ｈ', '##ｊ', '##ｕ', '##ｗ', '##ｚ']

zhuyin_char = ['ㄅ', 'ㄆ', 'ㆠ', 'ㄇ', 'ㄈ', 'ㄪ', 'ㄉ', 'ㄊ', 'ㄋ', 'ㆹ', 'ㄌ', 'ㄍ', 'ㄎ', 'ㆣ', 'ㄫ', 'ㄏ', 'ㆸ', 'ㄐ', 'ㄑ', 'ㆢ', 'ㄬ', 'ㄒ', 'ㆺ', 'ㄓ', 'ㄔ', 'ㄕ', 'ㄖ', 'ㄗ', 'ㄘ', 'ㆡ', 'ㄙ', 'ㆡ', 'ㆪ', 'ㄨ', 'ㆫ', 'ㆨ', 'ㄩ', 'ㄚ', 'ㆩ', 'ㆦ', 'ㆧ', 'ㄛ', 'ㄜ', 'ㄝ', 'ㆤ', 'ㆥ', 'ㄞ', 'ㆮ', 'ㄟ', 'ㄠ', 'ㆯ', 'ㄡ', 'ㆰ', 'ㆱ', 'ㆬ', 'ㄢ', 'ㄣ', 'ㄯ', 'ㄤ', 'ㆲ', 'ㄥ', 'ㆭ', 'ㄦ', 'ㄭ']

special_token = ['[PAD]', '[UNK]', '[CLS]', '[SEP]', '[MASK]', '<S>', '<T>']

japan_chars = ['ｲ', 'ｸ', 'ｼ', 'ｽ', 'ﾄ', 'ﾉ', 'ﾌ', 'ﾗ', 'ﾙ', 'ﾝ']

korean_chars = ['ᄀ', 'ᄁ', 'ᄂ', 'ᄃ', 'ᄅ', 'ᄆ', 'ᄇ', 'ᄈ', 'ᄉ', 'ᄋ', 'ᄌ', 'ᄎ', 'ᄏ', 'ᄐ', 'ᄑ', 'ᄒ', 'ᅡ', 'ᅢ', 'ᅣ', 'ᅥ', 'ᅦ', 'ᅧ', 'ᅨ', 'ᅩ', 'ᅪ', 'ᅬ', 'ᅭ', 'ᅮ', 'ᅯ', 'ᅲ', 'ᅳ', 'ᅴ', 'ᅵ', 'ᆨ', 'ᆫ', 'ᆯ', 'ᆷ', 'ᆸ', 'ᆺ', 'ᆻ', 'ᆼ', 'ᗜ']


with codecs.open(sys.argv[1], 'r', 'utf8') as fin,\
    codecs.open(sys.argv[2], 'w', 'utf8') as fout:
    cout_zh = 0
    cout_en = 0
    cout_ko = 0
    cout_jp = 0
    cout_em = 0
    cout_zh_res = 0
    cout_zh_tra = 0
    cout_zh_wp = 0
    cout_en_del = 0
    cout_num = 0
    cout_num_del = 0
    cout_hand_del = 0
    cout_total = 0
    cout_zhuyin = 0
    cout_unused = 0
    cout_special = 0
    cout_jpchars = 0
    cout_kochars = 0

    for line in fin:
        cout_total += 1
        token = line.strip()
        if not token:
            continue

        if token in human_list:
            cout_hand_del += 1  #13
            continue

        # chinese character
        elif re.match(u'[\u4e00-\u9fa5]+', token.replace('##', '')):
            cout_zh += 1  # 14642
            if re.match(u'##', token):
                cout_zh_wp += 1  #7321
                continue
            # print(token)
            else:
                token_simp = Converter('zh-hans').convert(token)
                if token_simp != token:
                    cout_zh_tra += 1  #1632
                    continue
                else:
                    cout_zh_res += 1  #5689
                    print(token, file=fout)
        # korean character
        elif re.match(u'[\uac00-\ud7ff]+', token.replace('##', '')):
            # print(token)
            cout_ko += 1  #0
            continue

        # japanese character
        elif re.match(u'[\u30a0-\u30ff\u3040-\u309f]+', token.replace('##', '')):
            # print(token)
            cout_jp += 1  #553
            continue

        # english character
        elif re.match(u'[a-z]+', token.replace('##', '')):
            # print(token)
            cout_en += 1  #3557
            if re.match(u'##', token):
                # print(token)
                print(token, file=fout)
            elif len(token) > 1:
                # print(token)
                cout_en_del += 1  #2235
                continue
            else:
                # print(token)
                print(token, file=fout)

        # emoji character
        elif re.match(emoji_regex, token.replace('##', '')):
            # print(token)
            cout_em += 1  #56
            continue

        # multi-number characters
        elif re.match(u'(##)?\d', token):
            cout_num += 1
            if len(token.replace('##', '')) == 1:
                # print(token)
                print(token, file=fout)
            else:
                cout_num_del += 1  #1137
                # print(token)
                continue
        elif token.replace('##', '') in zhuyin_char:
            # print(token, file=fout)
            cout_zhuyin += 1
            continue
        elif token.startswith('[unused'):
            print(token, file=fout)
            cout_unused += 1
        elif token in special_token:
            print(token, file=fout)
            cout_special += 1
            
        elif token.replace('##', '') in japan_chars:
            cout_jpchars += 1
            continue

        elif token.replace('##', '') in korean_chars:
            cout_kochars += 1
            continue
        else:
            # print(token)
            print(token, file=fout)

    print("cout_zh:{}".format(cout_zh))
    print("cout_en:{}".format(cout_en))
    print("cout_ko:{}".format(cout_ko))
    print("cout_jo:{}".format(cout_jp))
    print("cout_em:{}".format(cout_em))
    print("cout_zh_res:{}".format(cout_zh_res))
    print("cout_zh_tra:{}".format(cout_zh_tra))
    print("cout_zh_wp:{}".format(cout_zh_wp))
    print("cout_en_del:{}".format(cout_en_del))
    print("cout_num:{}".format(cout_num))
    print("cout_num_del:{}".format(cout_num_del))
    print("cout_hand_del:{}".format(cout_hand_del))
    print("cout_total:{}".format(cout_total))
    print("cout_zhuyin:{}".format(cout_zhuyin))
    print("cout_unused:{}".format(cout_unused))
    print("cout_special:{}".format(cout_special))
    print("cout_jpchars:{}".format(cout_jpchars))
    print("cout_kochars:{}".format(cout_kochars))









