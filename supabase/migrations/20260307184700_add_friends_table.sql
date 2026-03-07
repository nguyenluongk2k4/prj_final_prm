-- Create friend_status enum type
CREATE TYPE friend_status AS ENUM ('pending', 'accepted', 'rejected');

-- Create friends table
CREATE TABLE public.friends (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user1_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    user2_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    status friend_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    -- Enforce ordering so pairs are stored consistently (user1_id < user2_id) to prevent (A,B) and (B,A) duplicates
    CHECK (user1_id < user2_id),
    UNIQUE (user1_id, user2_id)
);

-- Protect table with RLS
ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own friends list
CREATE POLICY "Users can view their own friends"
    ON public.friends FOR SELECT
    USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Policy: Users can insert/make friend requests
CREATE POLICY "Users can insert friends"
    ON public.friends FOR INSERT
    WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Policy: Users can update their friend statuses
CREATE POLICY "Users can update their friends"
    ON public.friends FOR UPDATE
    USING (auth.uid() = user1_id OR auth.uid() = user2_id)
    WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Performance Indexes
CREATE INDEX friends_user1_id_idx ON public.friends(user1_id);
CREATE INDEX friends_user2_id_idx ON public.friends(user2_id);
CREATE INDEX friends_status_idx ON public.friends(status);

-- Auto-update updated_at timestamp function (in case it wasn't created in init_schema)
CREATE OR REPLACE FUNCTION auto_update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply Auto-update trigger
CREATE TRIGGER update_friends_updated_at
    BEFORE UPDATE ON public.friends
    FOR EACH ROW
    EXECUTE FUNCTION auto_update_updated_at();
