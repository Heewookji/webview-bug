import 'package:comento_design_system/comento_design_system.dart';
import 'package:flutter/material.dart';
import 'package:webview_bug/edit_page.dart';
import 'package:webview_bug/sliver_delegate.dart';

enum ReadCaseType {
  answer,
  reply,
  nestedReply,
}

class Reply {
  final String text;
  final String nickname;
  final String? parentNickname;
  late final List<Reply> nestedReplies;
  Reply({
    required this.text,
    required this.nickname,
    this.parentNickname,
    List<Reply>? nestedReplies,
  }) {
    this.nestedReplies = nestedReplies ?? [];
  }
}

class Answer {
  final String text;
  final String nickname;
  late final List<Reply> replies;
  Answer({
    required this.text,
    required this.nickname,
    List<Reply>? replies,
  }) {
    this.replies = replies ?? [];
  }
}

class ReadCasePageArgs {
  late final String id;

  ReadCasePageArgs({required String path}) {
    id = path;
  }
}

class ReadCasePage extends StatefulWidget {
  static const routeName = '/read-case';

  const ReadCasePage({super.key});

  static Route generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => ReadCasePage(),
      settings: settings,
    );
  }

  @override
  State<ReadCasePage> createState() => _ReadCasePageState();
}

class _ReadCasePageState extends State<ReadCasePage> {
  final String title = '삼성 전자에 대해 질문 있습니다.';
  final String question = '''
삼성 전자 내부 분위기가 궁금합니다. 들어가고싶지는 않은데 어떻게 사는지 궁금하거든요.
그래서 내부에서는 어떤 식으로 일을 하나요?
저는 개발자인데 삼성 개발자들은 어떻게 일하는지가 너무 궁금합니다.
알려주세요! 빠른 답변 기다리겠습니다.
''';
  final List<Answer> answers = [
    for (int i = 0; i < 2; i++)
      Answer(
        text: '''
개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.
개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.
개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.
개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.
개념에 대한 답변을 하나도 못한 분들도 있습니다. 결과가 나올때까지는 몰라요.''',
        nickname: '빌에반스',
        replies: [
          Reply(nickname: '빌에반스', text: '제 답변에 질문 있으시면 남겨주세요.'),
          Reply(
            nickname: '쳇베이커',
            text: '저 지나가다가 이상한게 있어서 문의드립니다.',
            parentNickname: '빌에반스',
          ),
          Reply(
            nickname: '빌에반스',
            text: '네 말씀하세요.',
            parentNickname: '쳇베이커',
          ),
        ],
      ),
  ];
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  ReadCaseType type = ReadCaseType.answer;
  int selectedAnswerIndex = 0;
  int selectedReplyIndex = 0;
  Reply? selectedReply;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        controller.clear();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                _buildQuestion(),
                _buildAppBar(),
                _buildBody(),
              ],
            ),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          GestureDetector(
            onTap: () => focusNode.unfocus(),
            child: Container(
              color: CdsColors.white,
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CdsTextStyles.headline6),
                  SizedBox(height: 8),
                  Text(
                    '회사/산업 * BGF리테일/영업관리',
                    style: CdsTextStyles.caption.merge(
                      TextStyle(
                        color: CdsColors.grey400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    question,
                    style: CdsTextStyles.bodyText2,
                  ),
                  Text(
                    '2022.11.08',
                    style: CdsTextStyles.caption.merge(
                      TextStyle(color: CdsColors.grey400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverAppBarDelegate(
        title: title,
        question: question,
        onAnswer: () {
          Navigator.of(context).pushNamed(EditPage.routeName);
        },
      ),
    );
  }

  Widget _buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildContents(),
        ],
      ),
    );
  }

  Widget _buildContents() {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: SingleChildScrollView(
        child: Container(
          color: CdsColors.grey100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnswerCount(),
              _buildAnswerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      height: !focusNode.hasFocus ? 0 : 100,
      child: Opacity(
        opacity: !focusNode.hasFocus ? 0 : 1,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: CdsColors.blue100,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: CdsColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: TextFormField(
                    controller: controller,
                    maxLines: 10,
                    minLines: 1,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      prefix: selectedReply == null
                          ? SizedBox.shrink()
                          : Text(
                              '@${selectedReply!.nickname}  ',
                              style: TextStyle(
                                color: CdsColors.grey400,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  switch (type) {
                    case ReadCaseType.answer:
                      answers.add(Answer(
                        text: controller.text,
                        nickname: '나',
                      ));
                      break;
                    case ReadCaseType.reply:
                      answers[selectedAnswerIndex]
                          .replies
                          .add(Reply(text: controller.text, nickname: '나'));
                      break;
                    case ReadCaseType.nestedReply:
                      answers[selectedAnswerIndex]
                          .replies[selectedReplyIndex]
                          .nestedReplies
                          .add(
                            Reply(
                              text: controller.text,
                              nickname: '나',
                              parentNickname: selectedReply!.nickname,
                            ),
                          );
                      break;
                  }
                  focusNode.unfocus();
                },
                icon: Icon(Icons.send),
                color: CdsColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCount() {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      alignment: Alignment.bottomLeft,
      height: 40,
      child: Text('답변 ${answers.length}'),
    );
  }

  Widget _buildAnswerList() {
    return Column(
      children: [
        for (int i = 0; i < answers.length; i++) _buildAnswer(i, answers[i]),
      ],
    );
  }

  Widget _buildAnswer(int answerIndex, Answer answer) {
    return Container(
      color: CdsColors.white,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfile(answer),
          SizedBox(height: 16.0),
          Text(
            answer.text,
            style: CdsTextStyles.bodyText2,
          ),
          SizedBox(height: 32.0),
          Text(
            '2022.11.25',
            style: CdsTextStyles.caption.merge(
              TextStyle(
                color: CdsColors.grey400,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          _buildButton(answer, answerIndex, answer.replies.length),
          Divider(color: CdsColors.grey400),
          SizedBox(height: 8.0),
          _buildReplyList(answer, answerIndex, answer.replies),
        ],
      ),
    );
  }

  Widget _buildProfile(Answer answer) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: CdsColors.grey600,
            shape: BoxShape.circle,
          ),
          child: Text(
            answer.nickname[0],
            style: CdsTextStyles.bodyText1.merge(
              TextStyle(color: CdsColors.white),
            ),
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(answer.nickname),
            SizedBox(height: 4.0),
            Text(
              '코이사 채택률 82%',
              style: CdsTextStyles.caption.merge(
                TextStyle(color: CdsColors.grey400),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(Answer answer, int answerIndex, int replyLength) {
    return Row(
      children: [
        CdsTextButton.medium(
          onPressed: () {},
          text: 'ㅇ 좋아요 1',
          color: CdsComponentColor.red,
        ),
        CdsTextButton.medium(
          onPressed: () {
            type = ReadCaseType.reply;
            selectedAnswerIndex = answerIndex;
            selectedReply = null;
            focusNode.requestFocus();
          },
          text: 'ㅇ 댓글 $replyLength',
          color: CdsComponentColor.grey,
        ),
        CdsTextButton.medium(
          onPressed: () {},
          text: 'ㅇ 북마크 0',
          color: CdsComponentColor.grey,
        ),
      ],
    );
  }

  Widget _buildReplyList(Answer answer, int answerIndex, List<Reply>? replies) {
    if (replies == null) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < replies.length; i++)
          _buildReply(answerIndex, i, answer, replies[i]),
      ],
    );
  }

  Widget _buildReply(
      int answerIndex, int replyIndex, Answer answer, Reply reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReplyProfile(answerIndex, replyIndex, answer, reply),
          SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            color: CdsColors.grey200,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: reply.text),
              ]),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '2022.11.10',
            style: CdsTextStyles.caption.merge(
              TextStyle(color: CdsColors.grey400),
            ),
          ),
          for (int i = 0; i < reply.nestedReplies.length; i++)
            _buildNestedReply(
              answerIndex,
              replyIndex,
              answer,
              reply.nestedReplies[i],
            ),
        ],
      ),
    );
  }

  Widget _buildNestedReply(
    int answerIndex,
    int parentReplyIndex,
    Answer answer,
    Reply reply,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, left: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNestedReplyProfile(
              answerIndex, parentReplyIndex, answer, reply),
          SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            color: CdsColors.grey200,
            child: Text.rich(
              TextSpan(children: [
                if (reply.parentNickname != null)
                  TextSpan(
                      text: '@${reply.parentNickname} ',
                      style: TextStyle(
                        color: CdsColors.grey600,
                      )),
                TextSpan(text: reply.text),
              ]),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '2022.11.10',
            style: CdsTextStyles.caption.merge(
              TextStyle(color: CdsColors.grey400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedReplyProfile(
      int answerIndex, int parentReplyIndex, Answer answer, Reply reply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: CdsColors.grey300,
                shape: BoxShape.circle,
              ),
              child: Text(
                reply.nickname[0],
                style: CdsTextStyles.bodyText1.merge(
                  TextStyle(color: CdsColors.white, height: 1.0),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(reply.nickname),
          ],
        ),
        CdsTextButton.medium(
          color: CdsComponentColor.grey,
          onPressed: () {
            type = ReadCaseType.nestedReply;
            selectedAnswerIndex = answerIndex;
            selectedReplyIndex = parentReplyIndex;
            selectedReply = reply;
            focusNode.requestFocus();
          },
          text: '답글달기',
        ),
      ],
    );
  }

  Widget _buildReplyProfile(
      int answerIndex, int replyIndex, Answer answer, Reply reply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: CdsColors.grey300,
                shape: BoxShape.circle,
              ),
              child: Text(
                reply.nickname[0],
                style: CdsTextStyles.bodyText1.merge(
                  TextStyle(color: CdsColors.white, height: 1.0),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(reply.nickname),
          ],
        ),
        CdsTextButton.medium(
          color: CdsComponentColor.grey,
          onPressed: () {
            type = ReadCaseType.nestedReply;
            selectedAnswerIndex = answerIndex;
            selectedReplyIndex = replyIndex;
            selectedReply = reply;
            focusNode.requestFocus();
          },
          text: '답글달기',
        ),
      ],
    );
  }
}
