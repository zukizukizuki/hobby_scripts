import tweepy
import datetime

# Twitter APIの認証
consumer_key = 'your_consumer_key'
consumer_secret = 'your_consumer_secret'
access_token = 'your_access_token'
access_token_secret = 'your_access_token_secret'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

# Twitter APIの初期化
api = tweepy.API(auth)

def unfollow_inactive_users():
    # 3か月前の日付を計算する
    today = datetime.datetime.now()
    three_months_ago = today - datetime.timedelta(days=90)

    # フォローしているユーザーを取得する
    following = api.friends_ids()

    # フォローしているユーザーのアクティビティを確認し、アクティブでない場合は解除する
    for user_id in following:
        user = api.get_user(user_id)
        last_tweet = user.status.created_at if user.status else user.created_at
        if last_tweet < three_months_ago:
            api.destroy_friendship(user_id)
            print(f"Unfollowed inactive user: {user.screen_name}")

unfollow_inactive_users()
