from pathlib import Path
import re, json, html
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph, Table, TableStyle, Spacer
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.colors import HexColor, white
from reportlab.lib.pagesizes import A4, landscape
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.utils import ImageReader
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[2]
OUT = WORK / 'output/pdf/NutriGuide-Wellness-Stratejisi.pdf'
QA = WORK / 'tmp/pdfs/wellness'
OUT.parent.mkdir(parents=True, exist_ok=True)
QA.mkdir(parents=True, exist_ok=True)
for name, filename in [('Arial','arial.ttf'),('Arial-Bold','arialbd.ttf'),('Arial-Italic','ariali.ttf')]:
    pdfmetrics.registerFont(TTFont(name, 'C:/Windows/Fonts/'+filename))
pdfmetrics.registerFontFamily('Arial', normal='Arial', bold='Arial-Bold', italic='Arial-Italic', boldItalic='Arial-Bold')
NAVY=HexColor('#1B2838'); ORANGE=HexColor('#EF5826'); GRAY=HexColor('#59616D'); CREAM=HexColor('#FAF7F2'); LINE=HexColor('#E7DDD0')

def rich(s):
    s=s.replace('—','-').replace('–','-').replace('‑','-')
    tokens=[]
    def link(m):
        tokens.append('<link href="'+html.escape(m.group(2),quote=True)+'" color="#BF431C"><u>'+html.escape(m.group(1))+'</u></link>')
        return f'@@LINK{len(tokens)-1}@@'
    s=re.sub(r'\[([^\]]+)\]\(([^)]+)\)',link,s)
    s=html.escape(s)
    s=re.sub(r'\*\*(.*?)\*\*',r'<b>\1</b>',s)
    for i,v in enumerate(tokens): s=s.replace(f'@@LINK{i}@@',v)
    return s

def styles(size=11.3):
    return {
        'body':ParagraphStyle('body',fontName='Arial',fontSize=size,leading=size*1.42,textColor=NAVY,spaceAfter=6),
        'h2':ParagraphStyle('h2',fontName='Arial-Bold',fontSize=23,leading=28,textColor=NAVY,spaceAfter=15),
        'h3':ParagraphStyle('h3',fontName='Arial-Bold',fontSize=12.5,leading=17,textColor=NAVY,spaceBefore=6,spaceAfter=7),
        'bullet':ParagraphStyle('bullet',fontName='Arial',fontSize=size,leading=size*1.42,textColor=NAVY,leftIndent=10,firstLineIndent=-10,spaceAfter=7),
        'cell':ParagraphStyle('cell',fontName='Arial',fontSize=size-.6,leading=(size-.6)*1.35,textColor=NAVY),
        'small':ParagraphStyle('small',fontName='Arial',fontSize=8.6,leading=11.5,textColor=GRAY)
    }

def build_flow(text,width,fontsize):
    st=styles(fontsize); lines=text.strip().splitlines(); flow=[]; i=0
    while i<len(lines):
        s=lines[i].strip()
        if not s: i+=1; continue
        if s.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].strip().startswith('|'):
                cells=[v.strip() for v in lines[i].strip().strip('|').split('|')]
                if not all(re.fullmatch(r'[-: ]+',v) for v in cells): rows.append(cells)
                i+=1
            n=len(rows[0]); widths=[width*.19,width*.48,width*.33] if n==3 else [width/n]*n
            data=[[Paragraph(('<b>'+rich(v)+'</b>') if r==0 else rich(v),st['cell']) for v in row] for r,row in enumerate(rows)]
            t=Table(data,colWidths=widths,hAlign='LEFT')
            ts=[('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),9),('RIGHTPADDING',(0,0),(-1,-1),9),('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),8),('BACKGROUND',(0,0),(-1,0),HexColor('#F1E5D7')),('LINEBELOW',(0,0),(-1,0),.7,LINE)]
            for row in range(1,len(rows)):
                if row%2: ts.append(('BACKGROUND',(0,row),(-1,row),CREAM))
                ts.append(('LINEBELOW',(0,row),(-1,row),.35,LINE))
            t.setStyle(TableStyle(ts)); flow.extend([t,Spacer(1,11)]); continue
        if s.startswith('## '): flow.append(Paragraph(rich(s[3:]),st['h2']))
        elif s.startswith('### '): flow.append(Paragraph(rich(s[4:]),st['h3']))
        elif s.startswith('- '): flow.append(Paragraph('• '+rich(s[2:]),st['bullet']))
        elif re.match(r'^\d+\. ',s): flow.append(Paragraph(rich(s),st['bullet']))
        else:
            buff=[s]
            while i+1<len(lines) and lines[i+1].strip() and not re.match(r'^(#|- |\||\d+\. )',lines[i+1].strip()):
                i+=1; buff.append(lines[i].strip())
            flow.append(Paragraph(rich(' '.join(buff)),st['body']))
        i+=1
    return flow

def height(flow,width):
    total=0
    for f in flow:
        total+=f.getSpaceBefore()+f.wrap(width,10000)[1]+f.getSpaceAfter()
    return total

def furniture(c,w,h,pageno,label):
    c.setFillColor(white); c.rect(0,0,w,h,fill=1,stroke=0)
    c.setFillColor(ORANGE); c.rect(40,h-32,23,3,fill=1,stroke=0)
    c.setFillColor(NAVY); c.setFont('Arial-Bold',8)
    c.drawString(71,h-32,'NUTRIGUIDE / WELLNESS STRATEJİSİ')
    c.setFillColor(GRAY); c.setFont('Arial',8); c.drawRightString(w-40,h-32,label)
    c.setStrokeColor(LINE); c.line(40,36,w-40,36)
    c.setFont('Arial',7.6); c.drawString(40,23,'7 Eylül 2026  |  Ürün önerisi ve örnek ekranlar')
    c.drawRightString(w-40,23,f'{pageno:02d} / 14')

source=(ROOT/'report-source.md').read_text(encoding='utf-8')
parts=re.split(r'<!-- PAGE:(.*?) -->',source)
c=canvas.Canvas(str(OUT),pagesize=A4,pageCompression=1)
c.setTitle('NutriGuide Wellness - Ürün Stratejisi ve Ekran Tasarımları')
c.setAuthor('NutriGuide - Tasarım araştırması')
checks=[]
for k in range(1,len(parts),2):
    meta=parts[k].split('|'); body=parts[k+1]; pageno=int(meta[0]); is_image=meta[1]=='IMAGE'
    w,h=landscape(A4) if is_image else A4
    c.setPageSize((w,h)); furniture(c,w,h,pageno,('Uygulama içi tasarım' if is_image else meta[1]))
    if is_image:
        name=meta[2]; filename=name+'-v2' if name=='03-nefes-ve-uyku' else name
        path=ROOT/'screens'/f'{filename}.png'
        if not path.exists(): raise FileNotFoundError(path)
        paras=[x.strip() for x in body.strip().splitlines() if x.strip()]
        caption=' '.join(x for x in paras if not x.startswith('##'))
        im=ImageReader(str(path)); iw,ih=im.getSize(); maxw=w-64; maxh=h-122
        scale=min(maxw/iw,maxh/ih); dw,dh=iw*scale,ih*scale
        c.drawImage(im,(w-dw)/2,h-47-dh,dw,dh)
        cap=Paragraph(rich(caption),styles()['small']); cw,ch=cap.wrap(w-80,80)
        if ch>40: raise ValueError('Image caption too tall')
        cap.drawOn(c,40,43)
        checks.append({'page':pageno,'type':'image','image':name,'dimensions':[iw,ih],'captionHeight':ch})
    else:
        width=w-84; top=h-65
        if pageno==1:
            c.setFillColor(NAVY); c.setFont('Arial-Bold',30)
            c.drawString(42,h-96,'NutriGuide Wellness')
            c.setFillColor(GRAY); c.setFont('Arial',11)
            c.drawString(42,h-119,'Günlük iyi oluşu, tabağa ve küçük eylemlere bağlayan ürün')
            top=h-154
        available=top-53
        for fs in [11.3,11.1,10.9,10.7,10.5,10.3,10.1]:
            flow=build_flow(body,width,fs); used=height(flow,width)
            if used<=available: break
        if used>available: raise ValueError(f'Page {pageno} overflow {used:.1f}>{available:.1f}')
        y=top
        for f in flow:
            y-=f.getSpaceBefore(); fw,fh=f.wrap(width,10000); y-=fh; f.drawOn(c,42,y); y-=f.getSpaceAfter()
        checks.append({'page':pageno,'type':'text','bodyFont':fs,'bottom':round(y,2),'used':round(used,2)})
    c.showPage()
c.save()
reader=PdfReader(str(OUT))
assert len(reader.pages)==14
for n,page in enumerate(reader.pages,1):
    txt=page.extract_text() or ''
    assert str(n).zfill(2)+' / 14' in txt, (n,'footer absent')
links=sum(len(p.get('/Annots',[])) for p in reader.pages)
assert links>=35, links
(QA/'layout-checks.json').write_text(json.dumps({'pages':checks,'linkCount':links,'output':str(OUT)},ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'output':str(OUT),'pages':len(reader.pages),'links':links,'layouts':checks},ensure_ascii=False))
